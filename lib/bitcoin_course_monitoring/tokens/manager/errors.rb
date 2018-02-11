# encoding: utf-8

module BitcoinCourseMonitoring
  module Tokens
    class Manager
      # @author Алейников Максим <m.v.aleinikov@gmail.com>
      #
      # Модуль, предоставляющий пространства имён для классов ошибок,
      # используемых содержащим классом
      #
      module Errors
        # @author Алейников Максим <m.v.aleinikov@gmail.com>
        #
        # Пространство имён классов ошибок, связанных с информацией о токене
        # авторизации
        #
        module TokenInfo
          # @author Алейников Максим <m.v.aleinikov@gmail.com>
          #
          # Класс ошибок, сигнализирующих о том, что токен авторизации не
          # является зарегистрированным
          #
          class NotFound < RuntimeError
            # Инциализирует объект класса
            #
            # @param [String] token
            #   токен авторизации
            #
            def initialize(token)
              # Токен авторизации #{token} не является зарегистрированным
              super(<<-MESSAGE.squish)
                Необходима авторизация
              MESSAGE
            end
          end
        end

        # @author Алейников Максим <m.v.aleinikov@gmail.com>
        #
        # Пространство имён классов ошибок, связанных с токеном авторизации
        #
        module Token
          # @author Алейников Максим <m.v.aleinikov@gmail.com>
          #
          # Класс ошибок, сигнализирующих о том, что токен авторизации не
          # действителен
          #
          class Expired < RuntimeError
            # Инциализирует объект класса
            #
            # @param [String] token
            #   токен авторизации
            #
            def initialize(token)
              super("Токен авторизации #{token} не действителен")
            end
          end
        end
      end
    end
  end
end
