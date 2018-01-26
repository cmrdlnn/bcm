# encoding: utf-8

# @author Алейников Максим <m.v.aleinikov@gmail.com>
#
# Файл поддержки тестирования контроллера Sinatra
#

require 'rack/test'

module Support
  module RackHelper
    include Rack::Test::Methods

    # Тестируемый REST-контроллер
    #
    def app
      IElections::API::REST::Controller
    end
  end
end

RSpec.configure do |config|
  config.include Support::RackHelper
end
