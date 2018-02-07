# encoding: utf-8

require 'openssl'
require 'securerandom'

module BitcoinCourseMonitoring
  # @author Алейников Максим <m.v.aleinikov@gmail.com>
  #
  # Пространство имён для модулей, включаемых в классы
  #
  module Helpers
    # @author Алейников Максим <m.v.aleinikov@gmail.com>
    #
    # Модуль для для создания пароля
    #
    module CreatePassword
      # Список строчных букв английского алфавита
      #
      DOWNCASE_SYMBOLS = ('a'..'z').to_a

      # Список прописных букв английского алфавита
      #
      UPCASE_SYMBOLS = ('A'..'Z').to_a

      # Список букв английского алфавита
      #
      SYMBOLS = DOWNCASE_SYMBOLS + UPCASE_SYMBOLS

      # Список цифр
      #
      DIGITS = ('0'..'9').to_a

      # Символы, используемые в пароле
      #
      PASSWORD_SYMBOLS = SYMBOLS + DIGITS

      # Длина пароля
      #
      LENGTH_PASSWORD = 16

      # Возвращает рандомную строку байт
      #
      # return [String]
      #  рандомная строка байт
      #
      def salt_
        @salt_ ||= SecureRandom.random_bytes(32)
      end

      # Создает пароль и возвращает его
      #
      # return [String]
      #  созданый пароль
      #
      def password_
        return @password unless @password.nil?
        body = PASSWORD_SYMBOLS.sample(LENGTH_PASSWORD - 2)
        first = SYMBOLS.sample
        last = DIGITS.sample
        body.unshift(first)
        body.push(last)
        @password = body.join
      end

      # Возвращает Дайджест пароля и соли
      #
      # @return [String]
      #  хэш-функции sha256
      #
      def password_hash_
        concat_salt = "#{password_}#{salt_}"
        OpenSSL::Digest.digest("SHA256", concat_salt)
      end
    end
  end
end
