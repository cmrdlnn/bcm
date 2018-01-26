# encoding: utf-8

# @author Алейников Максим <m.v.aleinikov@gmail.com>
#
# Файл поддержки тестирования
#

require 'rspec'
require 'webmock/rspec'

RSpec.configure do |config|
  # Убираем поддержку конструкций describe без префикса RSpec.
  config.expose_dsl_globally = false
end

require_relative '../config/app_init'

$spec = File.absolute_path(__dir__)

Dir["#{$spec}/helpers/**/*.rb"].each(&method(:require))
Dir["#{$spec}/shared/**/*.rb"].each(&method(:require))
Dir["#{$spec}/support/**/*.rb"].each(&method(:require))
