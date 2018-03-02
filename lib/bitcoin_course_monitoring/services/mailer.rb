# encoding: utf-8

require 'net/smtp'

module BitcoinCourseMonitoring
  # @author Алейников Максим <m.v.aleinikov@gmail.com>
  #
  # Пространство имен для сервисов работающих с внешними апи бирж
  #
  module Services
    # @author Алейников Максим <m.v.aleinikov@gmail.com>
    #
    # Класс создающий SMTP сервер для отправки электронной почты
    #
    class Mailer
      class << self
        FROM = 'support@bcm.com'.freeze

        SERVER = ENV['BCM_SMTP_SERVER']

        PORT = ENV['BCM_SMTP_PORT']

        CAPTION = 'С уважением, команда BitcoinTrader.'.freeze

        # Отправляет письмо по электронной почте
        #
        # @param [Hash] to
        #  параметры отправки письма
        #
        def user_created(opts = {})
          msg = <<-EOF
            Добро пожаловать!
            Ваш логин: #{opts[:login]}
            Пароль: #{opts[:password]}

            #{CAPTION}
          EOF

          send_mail(msg, opts[:login])
        end

        def email_changed(old_email, new_email, confirm_token, address)
          send_mail(
            msg_to_old_email(old_email),
            old_email
          )
          send_mail(
            msg_to_new_email(new_email, confirm_token, address),
            new_email
          )
        end

        def password_changed(email)
          msg = <<-EOF
            Внимание!
            Ваш пароль был изменён.
            Если это произошло по ошибке - обратитесь к администратору системы

            #{CAPTION}
          EOF

          send_mail(msg, email)
        end

        private_class_method

        def msg_to_old_email(email)
          <<-EOF
            Внимание!
            Система получила запрос на смену логина #{email}.

            #{CAPTION}
          EOF
        end

        def msg_to_new_email(email, confirm_token, address)
          <<-EOF
            Здравствуйте!
            Ваш логин в системе был изменён на #{email}.
            Если Вы получили это сообщение по ошибке - просто проигнорируйте его.
            Для смены логина перейдите по ссылке:

            #{address}/confirm/#{confirm_token}

            #{CAPTION}
          EOF
        end

        def send_mail(message, to)
          Net::SMTP.start(SERVER, PORT) do |smtp|
            smtp.send_message message, FROM, to
          end
        end
      end
    end
  end
end
