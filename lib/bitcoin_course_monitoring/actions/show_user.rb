# encoding: utf-8

require_relative 'base/authorized_action'

module BitcoinCourseMonitoring
  module Actions
    # @author Алейников Максим <m.v.aleinikov@gmail.com>
    #
    # Класс бизнес-логики получения информации о пользователе
    #
    class ShowUser < Base::AuthorizedAction
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
      def initialize(id, token)
        super(token)
        @id = id
      end

      # Идентификатор записи пользователя
      #
      attr_reader :id

      # Возвращает запись пользователя
      #
      # @return [Array<Hash, String>]
      #  запись пользователя и обновленный токен
      #
      def show
        check_admin!
        [user, refresh_token]
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

      # Возвращает запись пользователя
      #
      # @return [Hash]
      #  запись пользователя
      #
      def user
        BitcoinCourseMonitoring::Models::User
        .select(:id, :login, :first_name, :last_name, :role)
        .with_pk!(id).values
      end
    end
  end
end
