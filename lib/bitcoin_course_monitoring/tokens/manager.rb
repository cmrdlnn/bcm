# encoding: utf-8

require 'securerandom'
require 'singleton'

require "#{$lib}/settings/configurable"

require_relative 'manager/errors'

module BitcoinCourseMonitoring
  # @author Алейников Максим <m.v.aleinikov@gmail.com>
  #
  # Пространство имён поддержки токенов авторизации
  #
  module Tokens
    # @author Алейников Максим <m.v.aleinikov@gmail.com>
    #
    # Класс, предоставляющий функции управления токенами авторизации
    #
    class Manager
      extend  Settings::Configurable
      include Singleton

      settings_names :token_life_time

      # Выполняет следующие действия:
      #
      # *   удаляет токен авторизации, связанный с аргументом;
      # *   создаёт новый токен авторизации
      # *   привязывает созданный токен авторизации с аргументом, сохраняя эту
      #     связь и время её создания.
      #
      # Возвращает созданный токен авторизации.
      #
      # @param [Object] key
      #   аргумент
      #
      # @return [String]
      #   созданный токен авторизации
      #
      def self.register_key(key)
        instance.register_key(key)
      end

      # Возвращает объект, к которому привязан токен авторизации
      #
      # @param [#to_s] token
      #   токен авторизации
      #
      # @return [Object]
      #   объект, к которому привязан токен авторизации
      #
      # @raise [RuntimeError]
      #   если строковое представление аргумента не зарегистрировано в качестве
      #   токена авторизации
      #
      # @raise [RuntimeError]
      #   если время действия токена авторизации, которым является строковое
      #   представление аргумента, истекло
      #
      def self.find_key_by_token!(token)
        instance.find_key_by_token!(token)
      end

      # Выполняет следующие действия:
      #
      # *   удаляет токен авторизации, связанный с аргументом;
      # *   создаёт новый токен авторизации
      # *   привязывает созданный токен авторизации с аргументом, сохраняя эту
      #     связь и время её создания.
      #
      # Возвращает созданный токен авторизации.
      #
      # @param [Object] key
      #   аргумент
      #
      # @return [String]
      #   созданный токен авторизации
      #
      def register_key(key)
        token_info = create_token_info
        token_infos[key] = token_info
        token_info.token
      end

      # Возвращает объект, к которому привязан токен авторизации
      #
      # @param [#to_s] token
      #   токен авторизации
      #
      # @return [Object]
      #   объект, к которому привязан токен авторизации
      #
      # @raise [RuntimeError]
      #   если строковое представление аргумента не зарегистрировано в качестве
      #   токена авторизации
      #
      # @raise [RuntimeError]
      #   если время действия токена авторизации, которым является строковое
      #   представление аргумента, истекло
      #
      def find_key_by_token!(token)
        token = token.to_s
        key, token_info = token_infos.find { |obj, info| info.token == token }
        check_token_info!(token, token_info)
        key
      end

      private

      # @author Алейников Максим <m.v.aleinikov@gmail.com>
      #
      # Класс объектов с информацией о токене авторизации и времени, после
      # которого токен авторизации перестаёт быть действительным
      #
      TokenInfo = Struct.new(:token, :end)

      # Возвращает ассоциативный массив, ключами которого являются объекты, а
      # значениями — объекты класса {TokenInfo}
      #
      # @return [Hash{Object => TokenInfo}]
      #   результирующий ассоциативный массив
      #
      def token_infos
        @tokens ||= {}
      end

      # Создаёт новый токен авторизации и возвращает его
      #
      # @return [String]
      #   новый токен авторизации
      #
      def create_token
        SecureRandom.base64(32)
      end

      # Возвращает время действия токена авторизации в секундах
      #
      # @return [Integer]
      #   время действия токена авторизации в секундах
      #
      def token_life_time
        Manager.settings.token_life_time
      end

      # Создаёт новый объект класса {TokenInfo} и возвращает его
      #
      # @return [TokenInfo]
      #   новый объект класса {TokenInfo}
      #
      def create_token_info
        TokenInfo.new(create_token, Time.now + token_life_time)
      end

      # Проверяет, зарегистрирован ли токен авторизации и является ли он
      # действительным
      #
      # @param [String] token
      #   токен авторизации
      #
      # @param [NilClass, TokenInfo] token_info
      #   информация о токене авторизации, найденная среди зарегистрированных
      #   токенов авторизации
      #
      # @raise [RuntimeError]
      #   если токен авторизации не является зарегистрированным
      #
      # @raise [RuntimeError]
      #   если токен авторизации не действителен
      #
      def check_token_info!(token, token_info)
        found = token_info.is_a?(TokenInfo)
        raise Errors::TokenInfo::NotFound.new(token) unless found
        raise Errors::Token::Expired.new(token) if token_info.end < Time.now
      end
    end
  end
end
