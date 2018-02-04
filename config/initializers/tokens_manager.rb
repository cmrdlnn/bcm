# encoding: utf-8

# @author Алейников Максим <m.v.aleinikov@gmail.com>
#
# Файл настройки менеджера токенов авторизации
#

# Загрузка менеджера токенов авторизации
require "#{$lib}/tokens/manager.rb"

# Установка конфигурации менеджера токенов авторизации
BitcoinCourseMonitoring::Tokens::Manager.configure do |settings|
  # Время действия токена авторизации в секундах
  settings.set :token_life_time, 60 * 60
end
