# encoding: utf-8

require 'json'
require 'sequel'
require 'rest-client'

require "#{$lib}/errors/auth"
require "#{$lib}/helpers/log"
require "#{$lib}/tokens/manager"

module BitcoinCourseMonitoring
  module API
    module REST
      # @author Алейников Максим <m.v.aleinikov@gmail.com>
      #
      # Обработка ошибок
      #
      module Errors
        include BitcoinCourseMonitoring::Helpers::Log

        # @author Алейников Максим <m.v.aleinikov@gmail.com>
        #
        # Модуль вспомогательных методов
        #
        module Helpers
          # Возвращает объект, связанный с ошибкой
          #
          # @return [Exception]
          #   объект-исключение
          #
          def error
            env['sinatra.error']
          end
        end

        # Отображение классов ошибок в коды ошибок
        #
        ERRORS_MAP = {
          ArgumentError                                                         => 422,
          BitcoinCourseMonitoring::Errors::Auth::NotALogin                      => 401,
          BitcoinCourseMonitoring::Errors::Auth::NotAPassword                   => 401,
          BitcoinCourseMonitoring::Errors::Auth::NotFoundByToken                => 403,
          BitcoinCourseMonitoring::Tokens::Manager::Errors::TokenInfo::NotFound => 403,
          BitcoinCourseMonitoring::Tokens::Manager::Errors::Token::Expired      => 403,
          JSON::ParserError                                                     => 422,
          RuntimeError                                                          => 422,
          # RestClient::BadRequest                                                => 400,
          # RestClient::Forbidden                                                 => 403,
          # RestClient::NotFound                                                  => 404,
          # RestClient::InternalServerError                                       => 422,
          # RestClient::Unauthorized                                              => 401,
          Sequel::DatabaseError                                                 => 422,
          Sequel::ForeignKeyConstraintViolation                                 => 422,
          Sequel::NoMatchingRow                                                 => 404,
          Sequel::InvalidValue                                                  => 422,
          Sequel::UniqueConstraintViolation                                     => 422
        }.freeze

        # Регистрация в контроллере обработчиков ошибок
        #
        # @param [BitcoinCourseMonitoring::API::REST::Controller] controller
        #   контроллер
        #
        def self.registered(controller)
          controller.helpers Helpers

          # Регистрирация обработчиков ошибок
          #
          ERRORS_MAP.each do |error_class, error_code|
            controller.error error_class do
              message = error.message
              log_error { <<~LOG }
                #{app_name_upcase} ERROR #{error.class} WITH MESSAGE #{message}
              LOG

              status error_code
              content = { message: message, error: error.class }
              body content.to_json
            end
          end

          # Обработчик всех остальных ошибок
          #
          # @return [Status]
          #   код ошибки
          #
          # @return [Hash]
          #   ассоциативный массив
          #
          controller.error 500 do
            log_error { <<~LOG }
              #{app_name_upcase} ERROR #{error.class} WITH MESSAGE
              #{error.message} AT #{error.backtrace.first(3)}
            LOG

            status 500
            content = { message: error.message, error: error.class }
            body content.to_json
          end
        end
      end

      Controller.register Errors
    end
  end
end
