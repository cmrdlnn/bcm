# encoding: utf-8

require_relative 'base/authorized_action'

module BitcoinCourseMonitoring
  module Actions
    # @author Алейников Максим <m.v.aleinikov@gmail.com>
    #
    # Класс бизнес-логики получения информации о пользователе
    #
    class CheckAuth < Base::AuthorizedAction
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

      # Проверяет: авторизован ли пользователь в системе
      #
      # @return [Array<Hash, String>]
      #  запись пользователя и обновленный токен
      #
      def check
        [user_values, refresh_token]
      end

      private

      # Возвращает запись пользователя
      #
      # @return [Hash]
      #  запись пользователя
      #
      def user
        users_dataset.first
      end

      # Возвращает значение атрибутов записи пользователя
      #
      # @param [BitcoinCourseMonitoring::Models::User]
      #  запись пользователя
      #
      # @return [Hash]
      #  значение атрибутов записи пользователя
      #
      def user_values
        user.values.except(:confirm_token, :new_email, :password_hash, :salt)
      end
    end
  end
end
