# encoding: utf-8

require_relative "base/base_authenticated"

module BitcoinCourseMonitoring
  module Services
    module Exmo
      # @author Алейников Максим <m.v.aleinikov@gmail.com>
      #
      # Класс возвращающий информацию об аккаунте пользователя
      #
      class UserInfo < BaseAuthenticated
        # Инициализирует клас объекта
        #
        def initialize(key, secret)
          @url = 'https://api.exmo.com/v1/user_info/'
          super(key, secret)
        end

        attr_reader :url

        # Возвращает информацию об аккаунте пользователя
        #
        # @return [Hash]
        #  ассоциативный массив с данными аккаунта
        #
        def user_info
          response =
            RestClient.post(url, payload, headers) { |resp, _request, _result| resp }
          p "user_info: #{response}"
          info = JSON.parse(response, symbolize_names: true)
          info.slice(:balances, :reserved, :error)
        rescue SocketError
          p 'In Socket error'
        end
      end
    end
  end
end
