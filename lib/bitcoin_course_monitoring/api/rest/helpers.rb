# encoding: utf-8

require "#{$lib}/helpers/log"

module BitcoinCourseMonitoring
  module API
    module REST
      # @author Алейников Максим <m.v.aleinikov@gmail.com>
      #
      # Модуль вспомогательных функций для REST-контроллера
      #
      module Helpers
        include BitcoinCourseMonitoring::Helpers::Log

        # Возвращает название сервиса в верхнем регистре без знаков
        # подчёркивания и дефисов. Необходимо для журнала событий.
        #
        # @return [String]
        #   преобразованное название сервиса
        #
        def app_name_upcase
          $app_name.upcase.tr('-', '_')
        end

        # Добавляет в журнал событий запись о запросе
        #
        def log_request
          log_debug(binding) { <<-LOG }
            #{app_name_upcase} #{request.request_method} REQUEST WITH URL
            #{request.url}, PARAMS #{params} AND BODY #{request.body}
          LOG
        end

        # Добавляет в журнал событий запись о возвращаемом ответе
        #
        def log_response
          log_debug(binding) do
            parts = [app_name_upcase, 'RESPONSE WITH STATUS', response.status]
            parts.push('AND BODY', body) if body.present?
            parts.join(' ')
          end
        end

        def action_params
          params.compact.tap { |hash| hash.delete(:captures) }
        end

        # Возвращает, предоставлен ли временный файл в параметрах метода REST
        # API
        #
        # @return [Boolean]
        #   предоставлен ли временный файл в параметрах метода REST API
        #
        def file?
          params[:file].is_a?(Hash) && params[:file][:tempfile].is_a?(Tempfile)
        end

        # Возвращает токен авторизации пользователя
        #
        # @return [String]
        #   токен авторизации пользователя
        #
        def token
          request.env['HTTP_X_CSRF_TOKEN']
        end
      end
    end
  end
end
