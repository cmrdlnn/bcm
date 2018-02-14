# encoding: utf-8

require_relative 'base/authorized_action'

module BitcoinCourseMonitoring
  module Actions
    class ChangePassword < Base::AuthorizedAction
      def initialize(params, token)
        super(token)
        @user = users_dataset.first
        @new_password = params[:new_password]
        @old_password = params[:old_password]
        @confirm_password = params[:confirm_password]
      end

      attr_reader :user, :old_password, :new_password, :confirm_password

      def change_password
        check_password!
        check_new_password!
        user.setup_password(new_password)
        send_message
        refresh_token
      end

      private

      def send_message
        return if user.role == 'administrator'
        BitcoinCourseMonitoring::Services::Mailer.password_changed(user.login)
      end

      def check_password_length!
        raise 'Новый пароль сликом короткий' if new_password.size < 6
      end

      def check_password!
        raise 'Неверный пароль' unless user.password?(old_password)
      end

      def check_new_password!
        raise 'Пароли не совпадают' if new_password != confirm_password
      end
    end
  end
end
