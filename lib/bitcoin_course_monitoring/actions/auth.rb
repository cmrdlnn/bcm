# encoding: utf-8

module BitcoinCourseMonitoring
  # @author Алейников Максим <m.v.aleinikov@gmail.com>
  #
  # Пространство имен для действий приложения
  #
  module Actions
    # @author Алейников Максим <m.v.aleinikov@gmail.com>
    #
    # Класс бизнес-логики аутентификации учётной
    #
    class Auth
      attr_reader :params

      # Инициализирует объект класса
      #
      # @param [Object] params
      #   параметры действия
      #
      # @raise [RuntimeError]
      #   если пароль некорректный
      #
      def initialize(params)
        @params = params
      end

      # Выполняет следующие действия
      #
      # *  Находит пользователя
      # *  Проверяет пароль
      # *  Возвращает данные найденного пользователя
      #
      # @return [Hash]
      #  данные полльзователя
      #
      def auth
        user = find_user
        check_user!(user)
        check_password!(user)
        user_info = user_values(user)
        token = Tokens::Manager.register_key(user.id)
        [user_info, token]
      end

      private

      # Возвращает значение параметра `login`
      #
      # @return [String]
      #   значение параметра `login`
      #
      def login
        params[:login]
      end

      # Возвращает значение параметра `password`
      #
      # @return [String]
      #   значение параметра `password`
      #
      def password
        params[:password]
      end

      # Возвращает значение атрибутов записи пользователя
      #
      # @param [BitcoinCourseMonitoring::Models::User]
      #  запись пользователя
      #
      # @return [Hash]
      #  значение атрибутов записи пользователя
      #
      def user_values(user)
        user.values.except(:confirm_token, :new_email, :password_hash, :salt)
      end

      # Ищет учётную запись пользователя и возвращает результат поиска
      #
      # @return [BitcoinCourseMonitoring::Models::User]
      #   найденная учётная запись пользователя
      #
      # @return [NilClass]
      #   если учётная запись пользователя не найдена
      #
      def find_user
        Models::User.first(login: login)
      end

      # Проверяет, что учётная запись администратора найдена по значению
      # параметра `login`
      #
      # @param [NilClass, IElections::Models::Admin]
      #   результат поиска учётной записи администратора по значению
      #   параметра `login`
      #
      # @raise [IElections::Errors::Auth::NotALogin]
      #   если учётная запись администратора не найдена по значению
      #   параметра `login`
      #
      def check_user!(user)
        return if user.is_a?(Models::User)
        raise Errors::Auth::NotALogin.new(login)
      end

      # Проверяет, что значение параметра `password` является паролем
      # предоставленной учётной записи
      #
      # @param [BitcoinCourseMonitoring::Models::User]
      #   учётная запись пользователя
      #
      # @raise [RuntimeError]
      #   если значение параметра `password` не является паролем
      #   предоставленной учётной записи
      #
      def check_password!(user)
        raise 'Некорректный пароль' unless user.password?(password)
      end
    end
  end
end
