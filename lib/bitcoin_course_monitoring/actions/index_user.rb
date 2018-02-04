# encoding: utf-8

require_relative 'base/authorized_action'

module BitcoinCourseMonitoring
  module Actions
    # @author Алейников Максим <m.v.aleinikov@gmail.com>
    #
    # Класс бизнес-логики получения информации о пользователях
    #
    class IndexUser
      # Инициализирует объект класса
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

      # Возвращает список записей пользователей
      #
      # @return [Array<Array<Hash>, String>]
      #  список записей пользователей и обновленный токен
      #
      def index
        [users, refresh_token]
      end

      private

      # Возвращает список записей пользователей
      #
      # @return [Array<Hash>]
      #  список записей пользователей
      #
      def users
        BitcoinCourseMonitoring::Models::User
        .select(:id, :first_name, :last_name).naked.all
      end
    end
  end
end
