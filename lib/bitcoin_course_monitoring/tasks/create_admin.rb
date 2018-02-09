# encoding: utf-8

require "#{$lib}/helpers/log"
require "#{$lib}/helpers/create_password"

module BitcoinCourseMonitoring
  module Tasks
    # @author Алейников Максим <m.v.aleinikov@gmail.com>
    #
    # Класс объектов, создающий учетную запись администратора
    #
    class CreateAdmin
      include Helpers::Log
      include Helpers::CreatePassword

      # Создает учетную запись администратора голосования
      #
      def self.launch!
        new.launch!
      end

      # Создает учетную запись администратора голосования
      #
      def launch!
        if count_admin.zero?
          BitcoinCourseMonitoring::Models::User.create(params)
        elsif count_admin.positive?
          BitcoinCourseMonitoring::Models::User
          .where(role: 'administrator')
          .order(:id).first.update(params)
        end

        log_info { 'Учетная запись администратора успешно создана' }
        log_info { 'Название учётной записи администратора(login): admin' }
        log_info { "Пароль учётной записи администратора: #{password_}" }

      end

      private

      # Возвращает количетсво учетных записей администраторов
      #
      # return [Integer]
      #  количество учетных записей
      #
      def count_admin
        BitcoinCourseMonitoring::Models::User.where(role: 'administrator').count
      end

      # Параметры для создания или обновления учетной записи администратора
      #
      # return [Hash]
      #  параметры
      #
      def params
        {
          login: 'admin',
          role: 'administrator',
          salt: salt_,
          password_hash: password_hash_
        }
      end
    end
  end
end
