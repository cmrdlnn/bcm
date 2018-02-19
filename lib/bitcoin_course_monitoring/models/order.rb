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
      plugin :instance_hooks

      # Запускает создание ордера на бирже после создания записи ордера в системе
      #
      def after_create
        super
        order_create
      end

      # Создает ордер в системе exmo
      #
      def order_create
        order = Services::Exmo::OrderCreate.new(key, secret, create_order_data).order_create
        if order[:error].empty?
          update(order_id: order[:order_id])
          tracking_order
        else
          update(state: 'error')
        end
      end

      private

      # Отслеживает ордер, меняет его состояние в зависимости от полученных данных
      #
      def tracking_order
        Thread.new do
          loop do
            sleep 3
            order_info = Services::Exmo::OrderTrades.new(key, secret, params).order_trades
            trades = order_info[:trades]
            next if trades.nil?
            next if trades.blank?
            sum = trades.reduce(0) do |memo, trade|
              memo + trade[:quantity]
            end
            update(amount: sum)
            update(state: 'fulfilled') if sum == quantity
            brake if state == 'canceled' || state == 'fulfilled'
          end
        end
      end

      # Отменяет ордер
      #
      def cancel_order
        Thread.new do
          loop do
            sleep 3
            result = Services::Exmo::OrderCancel.new(key, secret, params).order_cancel
            update(state: 'canceled') if result[:resilt] == true
            brake if result[:resilt] == true
          end
        end
      end

      # Подготавливает параметры для запроса
      #
      # @return [Hash]
      #  параметры для запроса
      #
      def params
        { order_id: order_id }
      end

      # Возвращает публичный ключ от аккаунта
      #
      # @return [String]
      #  публичный ключ
      #
      def key
        trade.key
      end

      # Возвращает секретный ключ от аккаунта
      #
      # @return [String]
      #  секретный ключ
      #
      def secret
        trade.secret
      end

      # Подготавливает данные для создания ордера
      #
      # @return [Hash]
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
