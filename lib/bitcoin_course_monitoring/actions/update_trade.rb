# encoding: utf-8

require_relative 'base/authorized_action'

module BitcoinCourseMonitoring
  module Actions
    # @author Алейников Максим <m.v.aleinikov@gmail.com>
    #
    # Класс бизнес-логики обновления записи торгов
    #
    class UpdateTrade
      # Инициализирует объект класса
      #
      # @param [Integer] id
      #   идентификатор записи торгов
      #
      # @param [Hash] params
      #   параметры запроса
      #
      # @param [#to_s] token
      #   токен авторизации
      #
      # @raise [BitcoinCourseMonitoring::Tokens::Manager::Errors::TokenInfo::NotFound]
      #   если токен авторизации не зарегистрирован
      #
      # @raise [BitcoinCourseMonitoring::Tokens::Manager::Errors::Token::Expired]
      #   если токен авторизации не действителен
      #
      def initialize(id, params, token)
        super(token)
        @id = id
        @params = params
      end

      # Идентификатор записи торгов, параметры
      #
      attr_reader :id, :params

      # Обновляет запись торгов
      #
      # @return [Array<Hash, String>]
      #  запись торгов и обновленный токен
      #
      def update_trade
        trade.update(params)
        trade_values = trade.reload.values
        [trade_values, refresh_token]
      end

      private

      # Возвращает запись торгов
      #
      # @return [Hash]
      #  запись торгов
      #
      def trade
        BitcoinCourseMonitoring::Models::Trade.with_pk!(id)
      end
    end
  end
end
