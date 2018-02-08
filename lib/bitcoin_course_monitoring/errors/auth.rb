# encoding: utf-8

module BitcoinCourseMonitoring
  # @author Алейников Максим <m.v.aleinikov@gmail.com>
  #
  # Модуль пространств имён классов ошибок, специфичных для приложения
  #
  module Errors
    # @author Алейников Максим <m.v.aleinikov@gmail.com>
    #
    # Пространство имён классов ошибок аутентификации и авторизации
    #
    module Auth
      # @author Алейников Максим <m.v.aleinikov@gmail.com>
      #
      # Класс ошибок, сигнализирующих о том, что предоставленная строка не
      # является паролем учётной записи
      #
      class NotAPassword < RuntimeError
        # Инициализирует объект класс
        #
        def initialize
          super('Неверный пароль')
        end
      end

      # @author Алейников Максим <m.v.aleinikov@gmail.com>
      #
      # Класс ошибок, сигнализирующих о том, что предоставленная строка не
      # является названием учётной записи пользователя
      #
      class NotALogin < RuntimeError
        # Инициализирует объект класс
        #
        # @param [String] login
        #   строка, используемая в качестве учётной записи пользователя
        #
        def initialize(login)
          super(<<-MESSAGE.squish)
            Пользователь #{login} не найден
          MESSAGE
        end
      end

      # @author Алейников Максим <m.v.aleinikov@gmail.com>
      #
      # Класс ошибок, сигнализирующих о том, что учётная запись
      # пользователя не найдена по токену авторизации
      #
      class NotFoundByToken < RuntimeError
        # Инициализирует объект класс
        #
        def initialize
          super(<<-MESSAGE.squish)
            Учётная запись пользователя не найдена по токену авторизации
          MESSAGE
        end
      end
    end
  end
end
