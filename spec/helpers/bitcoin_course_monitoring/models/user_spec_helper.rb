# encoding: utf-8

require 'openssl'

module BitcoinCourseMonitoring
  module Models
    # @author Алейников Максим <m.v.aleinikov@gmail.com>
    #
    # Вспомогательный модуль для файла тестирование модели учетной записи пользователя
    #
    module UserSpecHelper
      # Возвращает Дайджест пароля и соли
      #
      # @param [String] password
      #   текст пароля
      #
      # @param [String] salt
      #   строка рандомных байт
      #
      # @return [String]
      #  хэш-функции sha256
      #
      def make_password(password, salt)
        concat_salt = "#{password}#{salt}"
        OpenSSL::Digest.digest("SHA256", concat_salt)
      end
    end
  end
end
