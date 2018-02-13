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
    # @!attribute type
    #   Тип ордера
    #   @return ['buy']
    #     если ордер на покупку
    #   @return ['sell']
    #     если ордер на продажу
    #
    # @!attribute pair
    #   Валютная пара
    #   @return [String]
    #     валютная пара
    #
    # @!attribute quantity
    #   Количество покупаемой или продаваемой криптовалюты
    #   @return [Flaot]
    #     количество покупаемой или продаваемой криптовалюты
    #
    # @!attribute price
    #   Цена покупки или продажи
    #   @return [Float]
    #     цена покупки или продажи
    #
    # @!attribute created_at
    #   Время создания записи
    #   @return [Time]
    #     время создания записи
    #
    # @!attribute trade_id
    #   Идентификатор записи торгов
    #   @return [Integer]
    #     идентификатор записи торгов
    #
    # @!attribute trade
    #   Запись торгов
    #   @return [BitcoinCourseMonitoring::Models::Trade]
    #     запись торгов
    #
    class Order < Sequel::Model
      # Отношения
      many_to_one :trade

      # Поддержка временных меток
      #
      plugin :timestamps, update_on_create: true

      after_create :order_create

      # Создает ордер в системе exmo
      #
      def order_create
        order = Services::Exmo::OrderCreate.new(key, secret, create_order_data).order_create
        update(order_id: order[:order_id])
      end

      private

      # Возвращает публичный ключ от аккаунта
      #
      # return [String]
      #  публичный ключ
      #
      def key
        trade.key
      end

      # Возвращает секретный ключ от аккаунта
      #
      # return [String]
      #  секретный ключ
      #
      def secret
        trade.secret
      end

      # Подготавливает данные для создания ордера
      #
      # return [Hash]
      #  данные для создания ордера
      #
      def create_order_data
        {
           type: type,
           price: price,
           quantity: quantity,
           pair: pair
        }
      end
    end
  end
end
