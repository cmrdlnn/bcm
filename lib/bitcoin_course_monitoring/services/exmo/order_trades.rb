# encoding: utf-8

require_relative 'base/base_authenticated'

module BitcoinCourseMonitoring
  module Services
    module Exmo
      # @author Алейников Максим <m.v.aleinikov@gmail.com>
      #
      # Класс возвращающий историю сделок по ордеру
      #
      class OrderTrades < BaseAuthenticated
        # Инициализирует клас объекта
        #
        def initialize(key, secret, params)
          @url = 'https://api.exmo.com/v1/order_trades/'
          super(key, secret, params)
        end

        attr_reader :url

        # Возвращает историю сделок по ордеру
        #
        # @return [Hash]
        #  ассоциативный массив с данными аккаунта
        #
        def order_trades
          response =
            RestClient.post(url, payload, headers) { |resp, _request, _result| resp }
          JSON.parse(response, symbolize_names: true)
        rescue SocketError, RestClient::Exceptions::ReadTimeout, Net::ReadTimeout
          p 'In Socket error'
        end
      end
    end
  end
end
