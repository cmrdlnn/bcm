# encoding: utf-8

module BitcoinCourseMonitoring
  # @author Алейников Максим <m.v.aleinikov@gmail.com>
  #
  # Пространство имен для сервисов работающих с внешними апи бирж
  #
  module Services
    # @author Алейников Максим <m.v.aleinikov@gmail.com>
    #
    # Пространство имен для работы с внешними апи биржи Exmo
    #
    module Exmo
      # @author Алейников Максим <m.v.aleinikov@gmail.com>
      #
      # Класс возвращающий информацию по крсу валютных пар
      #
      class Ticker

        # Инициализирует клас объекта
        #
        def initialize
          @url = 'https://api.exmo.com/v1/ticker/'
        end

        attr_reader :url

        # Запускает поток с get запросом на апи биржи
        # и получает данные о состоянии курса каждые 3 секунды
        # обновляя каждый раз глобальную переменную
        #
        #
        def get_ticker
          Thread.new do
            loop do
              sleep 3
              response = RestClient.get(url)
              pairs = JSON.parse(response.body, symbolize_names: true)
              pair = pairs[:BTC_USD]
              $pair = pair
            end
          end
        end

        #Ticker.new.get_ticker
      end
    end
  end
end
