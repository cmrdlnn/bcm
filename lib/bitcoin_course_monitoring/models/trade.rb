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
    # @!attribute pair
    #   Валютная пара
    #   @return [String]
    #     валютная пара
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
    # @!attribute created_at
    #   Время создания записи
    #   @return [Time]
    #     время создания записи
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
      one_to_many :orders

      # Поддержка временных меток
      #
      plugin :timestamps, update_on_create: true
      plugin :instance_hooks

      # Запускает логику торгов после создания модели.
      #
      def after_create
        super
        start_trade
      end

      attr_reader :bought

      def start_trade
        Services::Exmo::Trade.new(self, self.start_course).start
      end
    end
  end
end
