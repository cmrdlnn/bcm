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
      # Отправляет письмо по электронной почте
      #
      # @param [Hash] to
      #  параметры отправки письма
      #
      def self.send_mail(opts = {})
        opts[:from]        ||= 'support@bcm.com'
        opts[:server]      ||= 'localhost'
        msg = <<-EOF
          Добро пожаловать!
          Ваш логин: #{opts[:login]}
          Пароль: #{opts[:password]}

          С уважением, команда BitcoinTrader.
        EOF

        Net::SMTP.start(opts[:server]) do |smtp|
          smtp.send_message msg, opts[:from], opts[:login]
        end
      end
    end
  end
end
