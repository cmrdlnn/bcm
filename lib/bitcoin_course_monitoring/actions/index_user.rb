# encoding: utf-8

require_relative 'base/authorized_action'

module BitcoinCourseMonitoring
  module Actions
    # @author Алейников Максим <m.v.aleinikov@gmail.com>
    #
    # Класс бизнес-логики получения информации о пользователях
    #
    class IndexUser < Base::AuthorizedAction
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
        check_admin!
        [users, refresh_token]
      end

      private

      # Проверяет являеться ли пользователь администратором
      #
      # @return [Boolean]
      #  результат проверки
      #
      def check_admin!
        return if users_dataset.first.role == 'administrator'
        raise 'Неавторизованный запрос'
      end

      # Возвращает список записей пользователей
      #
      # @return [Array<Hash>]
      #  список записей пользователей
      #
      def users
        BitcoinCourseMonitoring::Models::User
          .select(:id, :login, :role).exclude(role: 'administrator').naked.all
      end
    end
  end
end
