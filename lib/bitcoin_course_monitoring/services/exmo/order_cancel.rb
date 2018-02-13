# encoding: utf-8

require_relative "base/base_authenticated"

module BitcoinCourseMonitoring
  module Services
    module Exmo
      # @author Алейников Максим <m.v.aleinikov@gmail.com>
      #
      # Класс отменяющий ордер на покупку или продажу
      #
      class OrderCreate < BaseAuthenticated
        # Инициализирует клас объекта
        #
        def initialize(key, secret, params)
          @url = 'https://api.exmo.com/v1/order_cancel/'
          super(key, secret, params)
        end

        attr_reader :url

        # Отменяет ордер на покупку или продажу
        #
        # @return [Hash]
        #  ассоциативный массив с данными аккаунта
        #
        def order_cansel
          response = RestClient.post(url, payload, headers)
          JSON.parse(response, symbolize_names: true)
        end
      end
    end
  end
end
