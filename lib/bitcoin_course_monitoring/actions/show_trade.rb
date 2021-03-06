# encoding: utf-8

require_relative 'base/authorized_action'

module BitcoinCourseMonitoring
  module Actions
    # @author Алейников Максим <m.v.aleinikov@gmail.com>
    #
    # Класс бизнес-логики получения информации о записи торгов
    #
    class ShowTrade < Base::AuthorizedAction
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
        [trade_values, balances, refresh_token]
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

      # Возвращает значение атрибутов запси торгов
      #
      # @return [Hash]
      #  значение атрибутов
      #
      def trade_values
        trade.values.merge(trade_orders)
      end

      # Возвращает ордера связанные с торгами
      #
      # @return [Hash]
      #  ордера
      #
      def trade_orders
        orders = trade.orders_dataset.naked.order(:created_at).all
        { orders: orders }
      end

      # Возвращает запись торгов
      #
      # @return [Hash]
      #  запись торгов
      #
      def trade
        @trade ||= BitcoinCourseMonitoring::Models::Trade
                   .where(user_id: user_id, id: id).first!
      end

      # Возвращает баланс аккаунта пользователя
      #
      # @return [Hash]
      #  баланс аккаунта пользователя
      #
      def balances
        key = trade.key
        secret = trade.secret
        Services::Exmo::UserInfo.new(key, secret).user_info
      end
    end
  end
end
