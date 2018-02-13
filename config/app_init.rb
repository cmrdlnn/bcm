# encoding: utf-8

# @author Алейников Максим <m.v.aleinikov@gmail.com>
#
# Файл инициализации сервиса
#

require 'logger'
require 'dotenv'
require 'rest-client'

# Корневая директория
$root = File.absolute_path("#{__dir__}/..")

# Окружение
$environment = ENV['RACK_ENV'] || 'development'

# Загрузка переменных окружения из .env файла
Dotenv.load(File.absolute_path("#{$root}/.env.#{$environment}"))

# Отключение буферизации стандартного потока вывода
STDOUT.sync = true

$logger = Logger.new(STDOUT)
$logger.level = ENV['BCM_LOG_LEVEL'] || Logger::DEBUG
$logger.progname = $PROGRAM_NAME
$logger.formatter = proc do |severity, time, progname, message|
  "[#{progname}] [#{time.strftime('%F %T')}] #{severity.upcase}: #{message}\n"
end

$app_name = 'bitcoin_course_monitoring'
$lib = "#{$root}/lib/#{$app_name}"
$pair = {}
$order_book = {}

# Загрузка инициализации составных частей приложения
Dir["#{__dir__}/initializers/*.rb"].sort.each(&method(:require))

# Загрузка инициализации, связанной с окружением
Dir["#{__dir__}/environments/*.rb"].sort.each(&method(:require))

Dir["#{$lib}/services/**/*.rb"].each(&method(:require))
