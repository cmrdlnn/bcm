# encoding: utf-8

module BitcoinCourseMonitoring
  module Services
    module Exmo
      # @author Алейников Максим <m.v.aleinikov@gmail.com>
      #
      # Класс возвращающий информацию по открытым ордерам
      #
      class AutoOrderBook

        # Инициализирует клас объекта
        #
        def initialize
          @url = 'https://api.exmo.com/v1/order_book/'
        end

        attr_reader :url

        # Запускает поток с get запросом на апи биржи
        # и получает данные по открытым ордерам каждую секунду
        # обновляя каждый раз глобальную переменную
        #
        #
        def get_order_book
          Thread.new do
            loop do
              sleep 1
              begin
              response =
                RestClient.get(url, params: { limit: 10, pair: 'BTC_USD' }) {|response, request, result| response }
              order_book = JSON.parse(response.body, symbolize_names: true)
              $order_book = order_book unless order_book.key?(:error)
              rescue SocketError => e
                puts "In Socket error"
              end
            end
          end
        end

        AutoOrderBook.new.get_order_book
      end
    end
  end
end
