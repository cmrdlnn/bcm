# encoding: utf-8

require_relative 'mixin'

module BitcoinCourseMonitoring
  module Settings
    # @author Алейников Максим <m.v.aleinikov@gmail.com>
    #
    # Модуль, предоставляющий функцию создания класса настроек по списку
    # названий настроек
    #
    module ClassFactory
      # Возвращает новый класс настроек по списку названий настроек
      #
      # @param [Array<#to_s>] names
      #   список названий настроек
      #
      # @return [Class]
      #   класс настроек
      #
      def self.create(*names)
        names.map! { |name| name.is_a?(Symbol) ? name : name.to_s.to_sym }
        Struct.new(*names) { include Mixin }
      end
    end
  end
end
