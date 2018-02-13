# encoding: utf-8

require 'net/https'

module BitcoinCourseMonitoring
  module Services
    module Exmo
      # @author Алейников Максим <m.v.aleinikov@gmail.com>
      #
      # Базовый класс для сервисов обращающихся к внешним апи требующих аутентификацию
      #
      class BaseAuthenticated
        # Инициализирует клас объекта
        #
        def initialize(key, secret, params = {})
          @key = key
          @secret = secret
          @params = params
        end

        attr_reader :key, :secret, :params

        # Подготавливает заголовок запроса
        #
        # @return [Hash]
        #  заголовок запроса
        #
        def headers
          {
            :Sign => sign,
            :Key => key
          }
        end

        # Подготавливает параметры запроса
        #
        # @param [Hash] params
        #  входящие параметры запроса
        #
        # @return [Hash]
        #  подготовленные параметры
        #
        def payload
          params.merge({ nonce: nonce })
        end

        # Возвращает
        #
        # @return [String]
        #  строка параметров
        #
        def post_data
          URI.encode_www_form(payload)
        end

        # Возвращает обязательный POST-параметр nonce с инкрементным числовым значением (>0)
        #
        # @return [String]
        #  строка с инкрементным числовым значением
        #
        def nonce
          nonce ||= Time.now.strftime("%s%3N")
        end

        # Возвращает дайджест
        #
        def digest
          OpenSSL::Digest.new('sha512')
        end

        # Подписывает строку параметров секретным ключом методом HMAC-SHA512
        #
        def sign
          OpenSSL::HMAC.hexdigest(digest, secret, post_data)
        end
      end
    end
  end
end
