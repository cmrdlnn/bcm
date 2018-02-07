# encoding: utf-8

# @author Алейников Максим <m.v.aleinikov@gmail.com>
#
# Файл настройки REST-контроллера
#

require 'rack/parser'

# Загрузка REST-контроллера
require "#{$lib}/api/rest/controller.rb"
# Загрузка поддержки исключений
require "#{$lib}/api/rest/errors.rb"

# Установка конфигурации REST-контроллера
BitcoinCourseMonitoring::API::REST::Controller.configure do |settings|
  settings.set    :bind, ENV['BCM_BIND']
  settings.set    :port, ENV['BCM_PORT']

  settings.disable :show_exceptions
  settings.enable  :dump_errors
  settings.enable  :raise_errors

  settings.use    Rack::CommonLogger, $logger

  settings.enable :static
  settings.set    :root, $root

  settings.use Rack::Parser, content_types: {
    'application/json' => proc { |body| ::MultiJson.decode body }
  }
end
