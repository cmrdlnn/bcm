# encoding: utf-8

require_relative "base/base_authenticated"

module BitcoinCourseMonitoring
  module Services
    module Exmo
      # @author Алейников Максим <m.v.aleinikov@gmail.com>
      #
      # Класс возвращающий совершенные сделки пользователя
      #
      class UserTrades < BaseAuthenticated
        # Инициализирует клас объекта
        #
        def initialize(key, secret, params)
          @url = 'https://api.exmo.com/v1/user_trades/'
          super(key, secret, params)
        end

        attr_reader :url

        # Возвращает совершенные сделки пользователя
        #
        # @return [Hash]
        #  ассоциативный массив с данными аккаунта
        #
        def user_trades
          response = RestClient.post(url, payload, headers)
          JSON.parse(response, symbolize_names: true)
        end
      end
    end
  end
end
