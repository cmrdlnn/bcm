# encoding: utf-8

require 'json'
require 'sinatra/base'

require_relative 'helpers'
require_relative '../../tasks/resumption_trading'

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

        def self.run!
          Services::Exmo::AutoOrderBook.new.order_book
          Tasks::ResumptionTrading.launch!
          Thread.abort_on_exception = true
          super
        end

        # Аутентифицирует учётную запись
        #
        # @param [Hash] params
        #  параметры запроса
        #
        # @return [Status]
        #   200
        #
        post '/api/auth' do
          content, token = Actions::Auth.new(params).auth
          headers 'X-CSRF-Token' => token
          body content.to_json
        end

        # Проверяет авторизацию пользователя в системе и возвращает его данные
        # если проверка успешна
        #
        # @param [Hash] params
        #  параметры запроса
        #
        # @return [Status]
        #   200
        #
        get '/api/auth/check' do
          content, new_token =
            Actions::CheckAuth.new(token).check
          headers 'X-CSRF-Token' => new_token
          status :ok
          body content.to_json
        end

        # Возвращает индекс записей пользователей
        #
        # @return [Status]
        #  200
        #
        get '/api/users' do
          content, new_token =
            Actions::IndexUser.new(token).index
          headers 'X-CSRF-Token' => new_token
          status :ok
          body content.to_json
        end

        # Возвращает запись пользователя по id
        #
        # @param [String] id
        #  идентификатор записи пользователя
        #
        # @return [Status]
        #  200
        #
        get '/api/users/:id' do |id|
          content, new_token =
            Actions::ShowUser.new(id, token).show
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
        put '/api/users/:id' do |id|
          content, new_token =
            Actions::UpdateUser.new(id, params, token).update_user
          headers 'X-CSRF-Token' => new_token
          status :ok
          body content.to_json
        end

        patch '/api/users/change_email' do
          address = request.env['HTTP_HOST']
          new_token =
            Actions::ChangeEmail.new(params, token, address).change_email
          headers 'X-CSRF-Token' => new_token
        end

        patch '/api/users/change_password' do
          new_token =
            Actions::ChangePassword.new(params, token).change_password
          headers 'X-CSRF-Token' => new_token
        end

        # Создает запись пользователя
        #
        # @param [String] body
        #  параметры запроса
        #
        # @return [Status]
        #  201
        #
        post '/api/users' do
          content, new_token =
            Actions::CreateUser.new(params, token).create_user
          headers 'X-CSRF-Token' => new_token
          status :created
          body content.to_json
        end

        # Удаляет запись пользователя по id
        #
        # @param [String] id
        #  идентификатор записи пользователя
        #
        # @return [Status]
        #  204
        #
        delete '/api/users/:id' do |id|
          new_token =
            Actions::DeleteUser.new(id, token).delete_user
          headers 'X-CSRF-Token' => new_token
          status :no_content
        end

        # Возвращает индекс записей торгов
        #
        # @return [Status]
        #  200
        #
        get '/api/trades' do
          content, new_token =
            Actions::IndexTrade.new(params, token).index
          headers 'X-CSRF-Token' => new_token
          status :ok
          body content.to_json
        end

        # Возвращает запись торгов по id
        #
        # @param [String] id
        #  идентификатор записи торгов
        #
        # @return [Status]
        #  200
        #
        get '/api/trades/:id' do |id|
          trade, balances, new_token =
            Actions::ShowTrade.new(id, token).show
          headers 'X-CSRF-Token' => new_token
          content = [trade, balances]
          status :ok
          body content.to_json
        end

        # Возвращает информацию об учётной записи пользователя на бирже
        #
        # @param [String] id
        #  идентификатор записи торгов
        #
        # @return [Status]
        #  200
        #
        post '/api/trades/user_info' do
          key = params[:key]
          secret = params[:secret]
          content = Services::Exmo::UserInfo
                    .new(key, secret)
                    .user_info
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
        put '/api/trades/:id' do |id|
          content, new_token =
            Actions::UpdateTrade.new(id, params, token).update_trade
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
        post '/api/trades' do
          content, new_token =
            Actions::CreateTrade.new(params, token).create_trade
          headers 'X-CSRF-Token' => new_token
          status :created
          body content.to_json
        end

        # Возвращает ордера на покупку и продажу по валютной паре
        #
        # @return [Status]
        #  200
        #
        get '/api/order_book' do
          content = Services::Exmo::OrderBook.new(params).order_book
          body content.to_json
        end

        # Возвращает курс пары
        #
        # @return [Status]
        #  200
        #
        get '/api/course' do
          content = Services::Exmo::Ticker.new.ticker
          body content.to_json
        end

        get '/confirm/:confirm_token' do |confirm_token|
          Actions::ChangeEmail.confirm(confirm_token)
          erb :index
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
