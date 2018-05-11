# encoding: utf-8

require_relative 'base/base_authenticated'

module BitcoinCourseMonitoring
  module Services
    module Exmo
      # @author Алейников Максим <m.v.aleinikov@gmail.com>
      #
      # Класс создающий задачу на вывод средств на кошелек
      #
      class WithdrawCrypt < BaseAuthenticated
        # Инициализирует клас объекта
        #
        def initialize(key, secret, params)
          @url = 'https://api.exmo.com/v1/withdraw_cryptwww/'
          super(key, secret, params)
        end

        attr_reader :url

        # Создает задачу на вывод средств на кошелек
        #
        # @return [Hash]
        #  ассоциативный массив с данными аккаунта
        #
        def withdraw_crypt
          response =
            RestClient.post(url, payload, headers) { |resp, _request, _result| resp }
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
