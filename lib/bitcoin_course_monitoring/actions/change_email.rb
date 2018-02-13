# encoding: utf-8

require_relative 'base/authorized_action'

module BitcoinCourseMonitoring
  module Actions
    class ChangeEmail < Base::AuthorizedAction
      def self.confirm(token)
        changeable_user = BitcoinCourseMonitoring::Models::User
                          .first(confirm_token: token)
        new_login = changeable_user.new_email
        changeable_user
          .update(login: new_login, new_email: nil, confirm_token: nil)
      end

      def initialize(params, token, address)
        super(token)
        @user = users_dataset.first
        @new_email = params[:new_email]
        @old_email = user.login
        @address = address
      end

      attr_reader :user, :new_email, :old_email, :address

      def change_email
        check_trader!
        send_message
        user.update(new_email: new_email, confirm_token: confirm_token)
        refresh_token
      end

      private

      def send_message
        BitcoinCourseMonitoring::Services::Mailer
          .email_changed(old_email, new_email, confirm_token, address)
      end

      def confirm_token
        @confirm_token ||= SecureRandom.hex(10)
      end

      def check_trader!
        return if user.role == 'trader'
        raise 'Неавторизованный запрос'
      end
    end
  end
end
