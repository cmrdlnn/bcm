# encoding: utf-8

require 'openssl'
require 'securerandom'
require "#{$lib}/helpers/log"

module BitcoinCourseMonitoring
  module Tasks
    # @author Алейников Максим <m.v.aleinikov@gmail.com>
    #
    # Класс объектов, создающий учетную запись администратора
    #
    class CreateAdmin
      include Helpers::Log

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

      # Создает учетную запись администратора голосования
      #
      def self.launch!
        new.launch!
      end

      # Создает учетную запись администратора голосования
      #
      def launch!
        if count_admin.zero?
          BitcoinCourseMonitoring::Models::Admin.create(params)
        elsif count_admin.positive?
          BitcoinCourseMonitoring::Models::Admin.order(:id).first.update(params)
        end

        log_info { 'Учетная запись администратора успешно создана' }
        log_info { 'Название учётной записи администратора(login): admin' }
        log_info { "Пароль учётной записи администратора: #{password}" }

      end

      private

      # Возвращает количетсво учетных записей администраторов
      #
      # return [Integer]
      #  количество учетных записей
      #
      def count_admin
        BitcoinCourseMonitoring::Models::Admin.count
      end

      # Возвращает рандомную строку байт
      #
      # return [String]
      #  рандомная строка байт
      #
      def salt
        @salt ||= SecureRandom.random_bytes(32)
      end

      # Создает пароль и возвращает его
      #
      # return [String]
      #  созданый пароль
      #
      def password
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
      def password_hash
        concat_salt = "#{password}#{salt}"
        OpenSSL::Digest.digest("SHA256", concat_salt)
      end

      # Параметры для создания или обновления учетной записи администратора
      #
      # return [Hash]
      #  параметры
      #
      def params
        {
          login: 'admin',
          name: 'Администратор',
          salt: salt,
          password_hash: password_hash
        }
      end
    end
  end
end
