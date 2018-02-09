# encoding: utf-8

require_relative 'base/authorized_action'

module BitcoinCourseMonitoring
  module Actions
    # @author Алейников Максим <m.v.aleinikov@gmail.com>
    #
    # Класс бизнес-логики удаления записи пользователя
    #
    class DeleteUser
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

      # Удаляет запись пользователя
      #
      # @raise [RuntimeError]
      #   если запрос не от администратора
      #
      # @return [Array<Hash, String>]
      #  запись пользователя и обновленный токен
      #
      def delete_user
        check_admin!
        user.delete
        refresh_token
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
      # @return [BitcoinCourseMonitoring::Models::User]
      #  запись пользователя
      #
      def user
        BitcoinCourseMonitoring::Models::User
        .with_pk!(id)
      end
    end
  end
end
