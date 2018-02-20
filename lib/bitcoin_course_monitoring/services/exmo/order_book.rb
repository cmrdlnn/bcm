# encoding: utf-8

module BitcoinCourseMonitoring
  module Services
    module Exmo
      # @author Алейников Максим <m.v.aleinikov@gmail.com>
      #
      # Класс возвращающий информацию по ордерам на покупку и продажу
      #
      class OrderBook
        # Инициализирует клас объекта
        #
        def initialize(params)
          @url = 'https://api.exmo.com/v1/order_book/'
          @limit = params[:limit]
          @pair = params[:pair]
        end

        attr_reader :url, :limit, :pair

        # Отправляет запрос на получение ордеров по валютным парам
        #
        # @param [Hash] pairs
        #  валютные пары example { pair: ['BTC_USD', 'BTC_EUR']}
        #
        # @return [Hash]
        #  информация об ордерах валютных пар
        #
        def order_book
          response =
            RestClient.get(url, params: { limit: limit, pair: pair }) { |resp, _request, _result| resp }
          JSON.parse(response.body, symbolize_names: true)
        rescue SocketError, RestClient::Exceptions::ReadTimeout, Net::ReadTimeout
          p 'In Socket error'
        end
      end
    end
  end
end
