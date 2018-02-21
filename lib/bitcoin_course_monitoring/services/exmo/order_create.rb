# encoding: utf-8

require_relative 'base/base_authenticated'

module BitcoinCourseMonitoring
  module Services
    module Exmo
      # @author Алейников Максим <m.v.aleinikov@gmail.com>
      #
      # Класс создающий ордер на покупку или продажу
      #
      class OrderCreate < BaseAuthenticated
        # Инициализирует клас объекта
        #
        def initialize(key, secret, params)
          @url = 'https://api.exmo.com/v1/order_create/'
          super(key, secret, params)
        end

        attr_reader :url

        # Создает ордер на покупку или продажу
        #
        # @return [Hash]
        #  ассоциативный массив с данными аккаунта
        #
        def order_create
          response =
            RestClient.post(url, payload, headers) { |resp, _request, _result| resp }
          p "response: #{response}"
          JSON.parse(response, symbolize_names: true)
        rescue => e
          error = "#{e.class}: #{e.message}:\n  #{e.backtrace.first}"
          $logger.error { error }
          { error: error }
        end
      end
    end
  end
end
