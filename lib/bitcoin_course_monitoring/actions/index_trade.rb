# encoding: utf-8

require_relative 'base/authorized_action'

module BitcoinCourseMonitoring
  module Actions
    # @author Алейников Максим <m.v.aleinikov@gmail.com>
    #
    # Класс бизнес-логики получения информации о торгах
    #
    class IndexTrade
      # Инициализирует объект класса
      #
      # @param [Integer] user_id
      #   Идентификатор записи пользователя
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
      def initialize(token)
        super(token)
      end

      # Возвращает список записей торгов
      #
      # @return [Array<Array<Hash>, String>]
      #  список записей пользователей и обновленный токен
      #
      def index
        [trades, refresh_token]
      end

      private

      # Возвращает список записей торгов
      #
      # @return [Array<Hash>]
      #  список записей торгов
      #
      def trades
        BitcoinCourseMonitoring::Models::Trade
        .where(user_id: user_id)
        .select(:id, :start_course, :margin, :order_price, :created_at).naked.all
      end
    end
  end
end
