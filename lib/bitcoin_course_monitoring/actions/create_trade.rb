# encoding: utf-8

require_relative 'base/authorized_action'

module BitcoinCourseMonitoring
  module Actions
    # @author Алейников Максим <m.v.aleinikov@gmail.com>
    #
    # Класс бизнес-логики создания записи торгов
    #
    class CreateTrade < Base::AuthorizedAction
      # Инициализирует объект класса
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
      def initialize(params, token)
        super(token)
        @params = params
      end

      # Параметры
      #
      attr_reader :params

      # Создает запись торгов
      #
      # @return [Array<Hash, String>]
      #  запись торгов и обновленный токен
      #
      def create_trade
        check_trader!
        create_data = params.merge(user_id: user_id, created_at: Time.now)
        trade = BitcoinCourseMonitoring::Models::Trade.create(create_data)
        trade_values = trade.values
        [trade_values, refresh_token]
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
    end
  end
end
