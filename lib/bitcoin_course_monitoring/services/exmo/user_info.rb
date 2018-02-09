# encoding: utf-8

require 'uri'

module BitcoinCourseMonitoring
  module Services
    module Exmo
      # @author Алейников Максим <m.v.aleinikov@gmail.com>
      #
      # Класс возвращающий информацию по крсу валютных пар
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
          response = RestClient.post(url, headers)
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
            Sign: sign,
            Key: key
          }
        end

        def post_data
          URI.encode_www_form({nance: nonce})
        end

        def nonce
          Time.now.strftime("%s%6N")
        end

        def digest
          OpenSSL::Digest.new('sha512')
        end

        def sign
          OpenSSL::HMAC.hexdigest(digest, secret, post_data)
        end
      end
    end
  end
end
