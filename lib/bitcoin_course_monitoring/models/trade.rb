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

      after_create :start_trade

      COMMISSION = 1.002

      attr_reader :bought

      # Запускает поток в котором идет процесс торгов, создаються ордера на покупку и на продажу
      #
      def start_trade
        @min = $order_book[:ask_top].to_f
        @max = $order_book[:bid_top].to_f
        Thread.new do
          loop do
            book = $order_book
            bid = book[:bid_top].to_f
            ask = book[:ask_top].to_f
            if bought
              if bid >= max
                @max = bid
              elsif start_course != max && (max - bid) / (max - start_course) <= marging
                @bought = false
                update(start_course: ask)
                @min = ask
                price = bid - 0.000001
                quantity = order_price / price * COMMISSION
                type = 'sell'
                create_data = create_order_data(price, quantity, type)
                Order.create(create_data)
              end
            else
              if ask <= min
                @min = ask
              elsif start_course == min && ask > min
                @bought = true
                update(start_course: bid)
                @max = bid
                price = ask + 0.000001
                quantity = order_price / price * COMMISSION
                type = 'buy'
                create_data = create_order_data(price, quantity, type)
                Order.create(create_data) if check_balance!
              elsif start_course != min && (ask - min) / (start_course - min) >= marging
                @bought = true
                update(start_course: bid)
                @max = bid
                price = ask + 0.000001
                quantity = order_price / price * COMMISSION
                type = 'buy'
                create_data = create_order_data(price, quantity, type)
                Order.create(create_data) if check_balance!
              end
            end
            sleep 1
          end
        end
      end

      private

      # Подготавливает данные для создания ордера
      #
      # @param [Float] price
      #  цена за еденицу
      #
      # @param [Float] quantity
      #  количество
      #
      # @param [String] type
      #  тип ордера
      #
      # @return [Hash]
      #  данные для создания ордера
      #
      def create_order_data(price, quantity, type)
        {
           type: type,
           price: price,
           quantity: quantity,
           pair: pair,
           trade_id: id
        }
      end

      # Проверяет баланс пользователя
      #
      # @return [Boolean]
      #  результат проверки
      #
      def check_balance!
        balance = Services::Exmo::UserInfo.new(key, secret).user_info
        balance[:balances][:USD] >= order_price
      end
    end
  end
end
