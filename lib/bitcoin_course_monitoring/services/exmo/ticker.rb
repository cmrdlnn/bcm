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
        def ticker
          response = RestClient.get(url) { |resp, _request, _result| resp }
          pairs = JSON.parse(response.body, symbolize_names: true)
          pairs[:BTC_USD]
        rescue => e
          error = "#{e.class}: #{e.message}:\n  #{e.backtrace.first}"
          p error
          { error: error }
        end
      end
    end
  end
end
