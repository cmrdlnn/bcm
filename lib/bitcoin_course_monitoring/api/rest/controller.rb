# encoding: utf-8

require 'json'
require 'sinatra/base'

require_relative 'helpers'

Dir["#{$lib}/actions/*.rb"].each(&method(:require))

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
        helpers Helpers

        # Аутентифицирует учётную запись администратора
        #
        # @param [Hash] params
        #  параметры запроса
        #
        # @return [Status]
        #   204
        #
        get '/api/auth' do
          content, token = BitcoinCourseMonitoring::Actions::Auth.new(params).auth
          headers 'X-CSRF-Token' => token
          status :no_content
          body content.to_json
        end

        # Возвращает индекс записей пользователей
        #
        # @return [Status]
        #  200
        #
        get 'api/users' do
          token = request.env['HTTP_X_CSRF_TOKEN']
          content, new_token =
            BitcoinCourseMonitoring::Actions::IndexUser.new(token).index
          headers 'X-CSRF-Token' => new_token
          status :ok
          body content.to_json
        end

        # Возвращает запись пользователя по id
        #
        # @parap [String] id
        #  идентификатор записи пользователя
        #
        # @return [Status]
        #  200
        #
        get 'api/users/:id' do |id|
          token = request.env['HTTP_X_CSRF_TOKEN']
          content, new_token =
            BitcoinCourseMonitoring::Actions::ShowUser.new(id, token).show
          headers 'X-CSRF-Token' => new_token
          status :ok
          body content.to_json
        end

        # Обновляет запись пользователя по id
        #
        # @param [String] id
        #  идентификатор записи пользователя
        #
        # @return [Status]
        #  200
        #
        put 'api/users/:id' do |id|
          token = request.env['HTTP_X_CSRF_TOKEN']
          params = JSON.parse(request.body.read, symbolize_names: true)
          content, new_token =
            BitcoinCourseMonitoring::Actions::UpdateUser.new(id, params, token).update_user
          headers 'X-CSRF-Token' => new_token
          status :ok
          body content.to_json
        end

        # Создает запись пользователя
        #
        # @param [String] body
        #  параметры запроса
        #
        # @return [Status]
        #  201
        #
        post 'api/users/' do
          token = request.env['HTTP_X_CSRF_TOKEN']
          params = JSON.parse(request.body.read, symbolize_names: true)
          content, new_token =
            BitcoinCourseMonitoring::Actions::CreateUser.new(params, token).create_user
          headers 'X-CSRF-Token' => new_token
          status :created
          body content.to_json
        end

        # Возвращает индекс записей торгов
        #
        # @return [Status]
        #  200
        #
        get 'api/trades' do
          token = request.env['HTTP_X_CSRF_TOKEN']
          content, new_token =
            BitcoinCourseMonitoring::Actions::IndexTrade.new(token).index
          headers 'X-CSRF-Token' => new_token
          status :ok
          body content.to_json
        end

        # Возвращает запись торгов по id
        #
        # @parap [String] id
        #  идентификатор записи торгов
        #
        # @return [Status]
        #  200
        #
        get 'api/trades/:id' do |id|
          token = request.env['HTTP_X_CSRF_TOKEN']
          content, new_token =
            BitcoinCourseMonitoring::Actions::ShowTrade.new(id, token).show
          headers 'X-CSRF-Token' => new_token
          status :ok
          body content.to_json
        end

        # Обновляет запись пользователя по id
        #
        # @param [String] id
        #  идентификатор записи пользователя
        #
        # @return [Status]
        #  200
        #
        put 'api/trades/:id' do |id|
          token = request.env['HTTP_X_CSRF_TOKEN']
          params = JSON.parse(request.body.read, symbolize_names: true)
          content, new_token =
            BitcoinCourseMonitoring::Actions::UpdateTrade.new(id, params, token).update_trade
          headers 'X-CSRF-Token' => new_token
          status :ok
          body content.to_json
        end

        # Создает запись пользователя
        #
        # @param [String] body
        #  параметры запроса
        #
        # @return [Status]
        #  201
        #
        post 'api/trades/' do
          token = request.env['HTTP_X_CSRF_TOKEN']
          params = JSON.parse(request.body.read, symbolize_names: true)
          content, new_token =
            BitcoinCourseMonitoring::Actions::CreateTrade.new(params, token).create_trade
          headers 'X-CSRF-Token' => new_token
          status :created
          body content.to_json
        end

        # Задаёт index.erb view по умолчанию для всех get запросов
        #
        get '/*' do
          erb :index
        end
      end
    end
  end
end
