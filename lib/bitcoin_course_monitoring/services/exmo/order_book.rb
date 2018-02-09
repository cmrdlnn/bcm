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
        def initialize(pair)
          @url = 'https://api.exmo.com/v1/order_book/'
          @pair = pair
        end

        attr_reader :url, :pair

        # Отправляет запрос на получение ордеров по валютным парам
        #
        # @param [Hash] pairs
        #  валютные пары example { pair: ['BTC_USD', 'BTC_EUR']}
        #
        # @return [Hash]
        #  информация об ордерах валютных пар
        #
        def get_order_book
          response = RestClient.get(url, params: pair)
          JSON.parse(response.body, symbolize_names: true)
        end
      end
    end
  end
end
