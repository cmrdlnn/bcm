# encoding: utf-8

namespace :bitcoin_course_monitoring do
  desc 'Осуществляет миграцию базы данных сервиса'
  task :migrate, [:to, :from] do |_task, args|
    # Загружаем начальную конфигурацию, в которой находится настройка
    # соединения с базой
    require_relative 'config/app_init'

    # Загружаем класс объектов, осуществляющих миграцию
    require "#{$lib}/tasks/migration"

    # Создаём соответствующий объект и запускаем миграцию
    to = args[:to]
    from = args[:from]
    dir = "#{$root}/db/migrations"
    db = Sequel::Model.db
    BitcoinCourseMonitoring::Tasks::Migration.launch!(db, to, from, dir)
  end

  # @author Алейников Максим <m.v.aleinikov@gmail.com>
  #
  desc 'Запускает контроллер REST API'
  task :run_rest_controller do
    require_relative 'config/app_init'

    BitcoinCourseMonitoring::API::REST::Controller.run!
  end

  # @author Алейников Максим <m.v.aleinikov@gmail.com>
  #
  desc 'Создает учетную запись администратора'
  task :seed do
    # Загружаем начальную конфигурацию, в которой находится настройка
    # соединения с базой
    require_relative 'config/app_init'

    # Загружаем класс объектов, осуществляющий создание учетной записи
    require "#{$lib}/tasks/create_admin"

    BitcoinCourseMonitoring::Tasks::CreateAdmin.launch!
  end
end
