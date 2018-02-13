# encoding: utf-8

require 'openssl'
require "#{$lib}/helpers/create_password"

module BitcoinCourseMonitoring
  # @author Алейников Максим <m.v.aleinikov@gmail.com>
  #
  # Пространство имён моделей
  #
  module Models
    # @author Алейников Максим <m.v.aleinikov@gmail.com>
    #
    # Модель учетной записи пользователя
    #
    # @!attribute id
    #   Идентификатор
    #   @return [Integer]
    #     идентификатор
    #
    # @!attribute login
    #   логин
    #   @return [String]
    #     логин
    #
    # @!attribute role
    #   роль учетной записи
    #   @return ['administrator']
    #     если роль учетной записи администратор
    #   @return ['trader']
    #     если роль учетной записи трейдер
    #
    # @!attribute salt
    #   Соль
    #   @return [String]
    #     соль
    #
    # @!attribute password_hash
    #   Дайджест пароля и соли
    #   @return [String]
    #     дайджест пароля и соли
    #
    # @!attribute created_at
    #   Время создания записи
    #   @return [Time]
    #     время создания записи
    #
    # @!attribute trades
    #   Записи торгов
    #   @return [Array<BitcoinCourseMonitoring::Models::Trade>]
    #     закрыты ли торги или нет
    #
    class User < Sequel::Model
      include Helpers::CreatePassword

      # Отношения
      one_to_many :trades

      # Поддержка временных меток
      #
      plugin :timestamps, update_on_create: true

      # Устанавливает пороль и возвращает его
      #
      # return [String]
      #  созданый пароль
      #
      def setup_password
        update(
          password_hash: password_hash_,
          salt: salt_
        )
        password_
      end

      # Возвращает, является ли предоставленный пароль паролем учётной записи
      #
      # @param [String] password
      #   пароль
      #
      # @return [Boolean]
      #   является ли предоставленный пароль паролем учётной записи
      #
      def password?(password)
        concat_salt = "#{password}#{salt}"
        digest = OpenSSL::Digest.digest("SHA256", concat_salt)
        password_hash == digest
      end
    end
  end
end
