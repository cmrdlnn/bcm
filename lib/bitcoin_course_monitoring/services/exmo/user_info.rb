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
          response = RestClient.post(url, payload, headers)
          info = JSON.parse(response, symbolize_names: true)
          balances = info.slice(:balances, :reserved)
        end
      end
    end
  end
end
