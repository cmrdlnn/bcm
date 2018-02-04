# encoding: utf-8

module BitcoinCourseMonitoring
  module Models
    # @author Алейников Максим <m.v.aleinikov@gmail.com>
    #
    # Модель учетной записи пользователя
    #
    # @!attribute id
    #   Идентификатор
    #   @return [Integer]
    #     идентификатор
    #
    # @!attribute key
    #   Публичный ключ
    #   @return [String]
    #     публичный ключ
    #
    # @!attribute secret
    #   Секретный ключ
    #   @return [String]
    #     секретный ключ
    #
    # @!attribute start_course
    #   Начальный курс торгов
    #   @return [Float]
    #     начальный курс торгов
    #
    # @!attribute margin
    #   Маржинальный доход торгов
    #   @return [Flaot]
    #     маржинальный доход торгов
    #
    # @!attribute order_price
    #   стоимость покупки
    #   @return [Float]
    #     стоимость покупки
    #
    # @!attribute user_id
    #   Идентификатор записи пользователя
    #   @return [Integer]
    #     идентификатор записи пользователя
    #
    # @!attribute user
    #   Запись пользователя
    #   @return [BitcoinCourseMonitoring::Models::User]
    #     запись пользователя
    #
    class Trade < Sequel::Model
      # Отношения
      many_to_one :user
    end
  end
end
