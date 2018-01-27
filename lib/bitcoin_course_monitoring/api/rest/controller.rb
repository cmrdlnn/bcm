# encoding: utf-8

require 'json'
require 'sinatra/base'

module BitcoinCourseMonitoring
  # @author Алейников Максим <m.v.aleinikov@gmail.com>
  #
  # Пространство имён для API
  #
  module API
    # @author Алейников Максим <m.v.aleinikov@gmail.com>
    #
    # Пространство имён для REST API
    #
    module REST
      # @author Алейников Максим <m.v.aleinikov@gmail.com>
      #
      # Класс контроллера REST API, основанный на Sinatra
      #
      class Controller < Sinatra::Base
        # Задаёт index.erb view по умолчанию для всех get запросов
        #
        get '/*' do
          erb :index
        end
      end
    end
  end
end
