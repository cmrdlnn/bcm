# frozen_string_literal: true

require 'rufus-scheduler'

module BitcoinCourseMonitoring
  # Модуль, предоставляющий функции для управления планировщиком
  module Scheduler
    # Создаёт и запускает планировщик, останавливая предыдущий, если тот
    # присутствовал
    def self.launch
      stop
      @scheduler = Rufus::Scheduler.new
    end

    # Останавливает планировщик, если тот присутствовал
    def self.stop
      @scheduler&.stop
      @scheduler = nil
    end

    # Вызывает блок через заданное время (см. формат метода `in` экземпляра
    # класса `Rufus::Scheduler`)
    # @param [String] period
    #   строка с заданным периодом
    def self.every(period, &block)
      @scheduler.every(period, &block)
    end
  end
end
