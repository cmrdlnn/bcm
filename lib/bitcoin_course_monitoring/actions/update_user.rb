# encoding: utf-8

require_relative 'base/authorized_action'

module BitcoinCourseMonitoring
  module Actions
    # @author Алейников Максим <m.v.aleinikov@gmail.com>
    #
    # Класс бизнес-логики обновления записи пользователя
    #
    class UpdateUser
      # Инициализирует объект класса
      #
      # @param [Integer] id
      #   идентификатор записи пользователя
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

      # Идентификатор записи пользователя, параметры
      #
      attr_reader :id, :params

      # Обновляет запись пользователя
      #
      # @return [Array<Hash, String>]
      #  запись пользователя и обновленный токен
      #
      def update_user
        check_admin!
        user.update(params)
        [user_values, refresh_token]
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

      # Возвращает ассоциативный массив атрибутов предоставленной записи
      # пользователя
      #
      # @return [Hash]
      #   ассоциативный массив атрибутов
      #
      def user_values
        {}.tap do |values|
          user.reload
          values[:id]         = user.id
          values[:first_name] = user.first_name
          values[:last_name]  = user.last_name
          values[:role]       = user.role
        end
      end

      # Возвращает запись пользователя
      #
      # @return [Hash]
      #  запись пользователя
      #
      def user
        BitcoinCourseMonitoring::Models::User.with_pk!(id)
      end
    end
  end
end
