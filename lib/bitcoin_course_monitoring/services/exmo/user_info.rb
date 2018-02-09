# encoding: utf-8
require 'net/https'

module BitcoinCourseMonitoring
  module Services
    module Exmo
      # @author Алейников Максим <m.v.aleinikov@gmail.com>
      #
      # Класс возвращающий информацию об аккаунте пользователя
      #
      class UserInfo

        # Инициализирует клас объекта
        #
        def initialize(key, secret)
          @url = 'https://api.exmo.com/v1/user_info/'
          @key = key
          @secret = secret
        end

        attr_reader :url, :key, :secret

        # Возвращает информацию об аккаунте пользователя
        #
        # @return [Hash]
        #  ассоциативный массив с данными аккаунта
        #
        def user_info
          response = RestClient.post(url, payload, headers)
          JSON.parse(response, symbolize_names: true)
        end

        private

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
          { nonce: nonce }
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
