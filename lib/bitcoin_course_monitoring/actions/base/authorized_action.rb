# encoding: utf-8

require "#{$lib}/errors/auth"

module BitcoinCourseMonitoring
  module Actions
    # @author Алейников Максим <m.v.aleinikov@gmail.com>
    #
    # Пространство имён базовых классов бизнес-логики взаимодействия с
    # браузерным приложением
    #
    module Base
      # @author Алейников Максим <m.v.aleinikov@gmail.com>
      #
      # Базовый класс бизнес-логики, проверяющих токен авторизации
      #
      class AuthorizedAction
        # Инициализирует объект класса
        #
        # @param [#to_s] token
        #   токен авторизации
        #
        def initialize(token)
          @token = token.to_s
          check_token!
        end

        private

        # Токен авторизации
        #
        # @return [String]
        #   токен авторизации
        #
        attr_reader :token

        # Возвращает значение идентификатора учётной записи администратора,
        # связанного с токеном авторизации
        #
        # @return [Integer]
        #   идентификатор учётной записи администратора
        #
        # @raise [BitcoinCourseMonitoring::Tokens::Manager::Errors::TokenInfo::NotFound]
        #   если токен авторизации не зарегистрирован
        #
        # @raise [BitcoinCourseMonitoring::Tokens::Manager::Errors::Token::Expired]
        #   если токен авторизации не действителен
        #
        def user_id
          @user_id ||= Tokens::Manager.find_key_by_token!(token)
        end

        # Возвращает запрос Sequel на получение учётных записей
        # администратора с идентификатором, значение которого связано с
        # токеном авторизации
        #
        # @return [Sequel::Dataset]
        #   результирующий запрос Sequel
        #
        # @raise [BitcoinCourseMonitoring::Tokens::Manager::Errors::TokenInfo::NotFound]
        #   если токен авторизации не зарегистрирован
        #
        # @raise [BitcoinCourseMonitoring::Tokens::Manager::Errors::Token::Expired]
        #   если токен авторизации не действителен
        #
        def users_dataset
          Models::User.where(id: user_id)
        end

        # Возвращает, существует ли учётная запись администратора с
        # идентификатором, значение которого связано с токеном авторизации
        #
        # @return [Boolean]
        #   существует ли учётная запись администратора с идентификатором,
        #   значение которого связано с токеном авторизации
        #
        def user_exists?
          users_dataset.count.positive?
        end

        # Проверяет следующее:
        #
        # *   зарегистрирован ли токен авторизации;
        # *   действителен ли токен авторизации;
        # *   существует ли учётная запись администратора с идентификатором,
        #     равным значению, прикреплённого к токену авторизации
        #
        # @raise [BitcoinCourseMonitoring::Tokens::Manager::Errors::TokenInfo::NotFound]
        #   если токен авторизации не зарегистрирован
        #
        # @raise [BitcoinCourseMonitoring::Tokens::Manager::Errors::Token::Expired]
        #   если токен авторизации не действителен
        #
        # @raise [BitcoinCourseMonitoring::Errors::Auth::Admin::NotFoundByToken]
        #   если учётная запись администратора с идентификатором, равным
        #   значению, прикреплённого к токену авторизации, не найдена
        #
        def check_token!
          raise Errors::Auth::NotFoundByToken.new unless user_exists?
        end

        # Возвращает новый токен авторизации, связанный с идентификатором
        # учётной записи администратора
        #
        # @return [String]
        #   новый токен авторизации
        #
        def refresh_token
          Tokens::Manager.register_key(user_id)
        end
      end
    end
  end
end
