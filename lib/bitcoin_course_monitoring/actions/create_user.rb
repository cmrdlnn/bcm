# encoding: utf-8

require_relative 'base/authorized_action'

module BitcoinCourseMonitoring
  module Actions
    # @author Алейников Максим <m.v.aleinikov@gmail.com>
    #
    # Класс бизнес-логики создания записи пользователя
    #
    class CreateUser < Base::AuthorizedAction
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
        @params = params.merge(role: 'trader')
      end

      # Параметры
      #
      attr_reader :params

      # Создает запись пользователя
      #
      # @return [Array<Hash, String>]
      #  запись пользователя и обновленный токен
      #
      def create_user
        check_admin!
        user = BitcoinCourseMonitoring::Models::User.create(params)
        password = user.setup_password
        send_password(password, user)
        user_values = user_values(user)
        [user_values, refresh_token]
      end

      private

      # Отправляет пароль по почте
      #
      # @param [String] password
      #  пароль
      #
      # @param [BitcoinCourseMonitoring::Models::User]
      #  запись пользователя
      #
      def send_password(password, user)
        opts = {
          login: user.login,
          password: password
        }
        BitcoinCourseMonitoring::Services::Mailer.user_created(opts)
      end

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
      def user_values(user)
        {
          id:         user.id,
          login:      user.login,
          role:       user.role,
          created_at: user.created_at
        }
      end
    end
  end
end
