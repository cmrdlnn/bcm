# encoding: utf-8

module BitcoinCourseMonitoring
  module Tasks
    # @author Алейников Максим <m.v.aleinikov@gmail.com>
    #
    # Класс объектов, возобновляющий торги после остановки сервера
    #
    class ResumptionTrading
      # Возобновляет торги после остановки сервера
      #
      def self.launch!
        new.launch!
      end

      # Возобновляет торги после остановки сервера
      #
      def launch!
        pairs = []
        trades.each do |trade|
          pairs.push(trade.pair.to_sym)
          if trade.orders.count.zero?
            course = trade.start_course
            Services::Exmo::Trade.new(trade, course, @stage).start
          else
            order_stage(trade.id)
            course = @start_course
            Thread.new do
              Services::Exmo::Trade.new(trade, course, @stage, @remainder, @order_id)
                .launch_trade
            end
          end
        end
        Services::Exmo::AutoOrderBook.new(pairs).order_book
      end

      attr_reader :start_course, :stage, :remainder, :order_id

      private

      # Возвращает список записей торгов
      #
      # @return [Array<BitcoinCourseMonitoring::Models::Trader>]
      #  список записей торгов
      #
      def trades
        BitcoinCourseMonitoring::Models::Trade.where(closed: false).all
      end

      # Записывает состояние и старт курс для продолжения торгов
      #
      def order_stage(trade_id)
        orders = orders(trade_id)
        @order_id = orders.last.id
        if orders.last.type == 'buy'
          buy_order(orders.last)
        elsif orders.last.type == 'sell'
          sell_order(orders.last)
        end
      end

      # Возвращает список записей ордеров по торгам
      #
      # @param [Integer] trade_id
      #  идентификатор записей торгов
      #
      # @return [Array<BitcoinCourseMonitoring::Models::Order>]
      #  список записей ордеров по торгам
      #
      def orders(trade_id)
        BitcoinCourseMonitoring::Models::Order
          .where(trade_id: trade_id).order(:created_at).all
      end

      # Записывает состояние и старт курс для продолжения торгов с момента
      # покупки
      #
      def buy_order(order)
        @remainder = 0
        if order.state == 'error'
          @stage = 1
        elsif order.amount.zero? && Time.now - order.created_at > 60
          order.cancel_order
          @stage = 1
        elsif order.amount.positive?
          @start_course = order.price
          @stage = 3
        end
      end

      # Записывает состояние, остаток по ордеру и старт курс для продолжения
      # торгов с момента продажи
      #
      def sell_order(order)
        if order.state == 'error'
          @remainder = 0
          @stage = 3
        elsif order.amount.zero? && Time.now - order.created_at > 60
          @remainder = 0
          order.cancel_order
          @stage = 3
        elsif order.amount < order.quantity
          @remainder = order.quantity - order.amount
          order.cancel_order
          @stage = 3
        elsif order.amount == order.quantity
          @remainder = 0
          @start_course = order.price
          @stage = 1
        end
      end
    end
  end
end
