# encoding: utf-8

require_relative 'base/authorized_action'

module BitcoinCourseMonitoring
  module Actions
    # @author Алейников Максим <m.v.aleinikov@gmail.com>
    #
    # Класс бизнес-логики получения информации о записи торгов
    #
    class ShowTrade
      # Инициализирует объект класса
      #
      # @param [Integer] id
      #   Идентификатор записи торгов
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
      def initialize(id, token)
        super(token)
        @id = id
      end

      # Идентификатор записи торгов
      #
      attr_reader :id

      # Возвращает запись торгов
      #
      # @return [Array<Hash, String>]
      #  запись торгов и обновленный токен
      #
      def show
        check_trader!
        [trade, refresh_token]
      end

      private

      # Проверяет являеться ли пользователь администратором
      #
      # @return [Boolean]
      #  результат проверки
      #
      def check_trader!
        return if users_dataset.first.role == 'trader'
        raise 'Неавторизованный запрос'
      end

      # Возвращает запись торгов
      #
      # @return [Hash]
      #  запись торгов
      #
      def trade
        BitcoinCourseMonitoring::Models::Trade
        .with_pk!(id).values
      end
    end
  end
end
