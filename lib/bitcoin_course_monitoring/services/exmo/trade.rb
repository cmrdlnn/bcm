# encoding: utf-8

module BitcoinCourseMonitoring
  module Services
    module Exmo
      # @author Алейников Максим <m.v.aleinikov@gmail.com>
      #
      # Класс запускающий процесс торгов
      #
      class Trade
        COMMISSION = 0.002

        def initialize(trade, course, stage = 1)
          @trade = trade
          @pair = trade.pair.to_sym
          @start_course = course
          @stage = stage
        end

        attr_reader :start_course

        attr_reader :trade, :pair

        attr_reader :order_id

        attr_reader :stage

        attr_reader :remainder

        def start
          Thread.new do
            loop do
              sleep 1
              break if trade_closed?
              next unless $order_book[pair] && $trend[pair]
              ask = $order_book[pair][:ask_top].to_f
              p "ask: #{ask}"
              p "start_course: #{start_course}"
              if ask <= start_course && $trend[pair][:ask_slope] == true
                buy(ask)
                launch_trade
                break
              end
            end
          end
        end

        def launch_trade
          loop do
            sleep 1
            break if trade_closed?
            next unless $order_book[pair] && $trend[pair]
            case stage
            when 1
              ask = $order_book[pair][:ask_top].to_f
              p "ask: #{ask}"
              p "Падение цены: #{start_course - ask}"
              buy(ask) if $trend[pair][:ask_slope] == true
            when 2
              check_buy_order
            when 3
              bid = $order_book[pair][:bid_top].to_f
              profit = profit(bid)
              p "bid: #{bid}"
              p "Прибыль: #{profit}"
              sell(bid) if profit.positive? && $trend[pair][:bid_slope] == true
            when 4
              check_sell_order
            end
          end
        end

        private

        def trade_closed?
          actual_trade = Models::Trade.with_pk(trade.id)
          actual_trade&.closed
        end

        def check_buy_order
          order = Models::Order.with_pk(order_id)
          if order.state == 'error'
            @stage = 1
          elsif order.amount.zero? && Time.now - order.created_at > 60
            order.cancel_order
            @stage = 1
          elsif order.amount < order.quantity && Time.now - order.created_at > 60
            order.cancel_order
            @start_course = order.price
            @stage = 3
          elsif order.amount == order.quantity
            @start_course = order.price
            @stage = 3
          end
        end

        def check_sell_order
          order = Models::Order.with_pk(order_id)
          if order.state == 'error'
            @stage = 3
          elsif order.amount.zero? && Time.now - order.created_at > 60
            order.cancel_order
            @stage = 3
          elsif order.amount < order.quantity && Time.now - order.created_at > 60
            order.cancel_order
            @remainder = order.quantity - order.amount
            @start_course = order.price
            @stage = 3
          elsif order.amount == order.quantity
            @remainder = 0
            @start_course = order.price
            @stage = 1
          end
        end

        def buy(ask)
          price = ask + 0.00000001
          quantity = (trade.order_price.to_f / price).floor(8)
          type = 'buy'
          create_data = create_order_data(price, quantity, type)
          return if check_balance!(type)
          p "create_data: #{create_data}"
          order = Models::Order.create(create_data)
          p "order: #{order}"
          @order_id = order.id
          p "BUY! #{price}"
          @stage = 2
        end

        def sell(bid)
          p "profit: #{profit(bid)}"
          price = bid - 0.00000001
          amount =
            Models::Order.where(trade_id: trade.id, type: 'buy').order(:created_at).last.amount
          quantity =
            remainder.zero? ? (amount * 0.998).floor(8) : remainder
          type = 'sell'
          create_data = create_order_data(price, quantity, type)
          return if check_balance!(type)
          p "create_data: #{create_data}"
          order = Models::Order.create(create_data)
          p "order: #{order}"
          @order_id = order.id
          p "SELL! #{price}"
          @stage = 4
        end

        def profit(bid)
          bid - start_course.to_f / (1 - COMMISSION) - bid * COMMISSION
        end

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
            trade_id: trade.id
          }
        end

        # Проверяет баланс пользователя
        #
        # @return [Boolean]
        #  результат проверки
        #
        def check_balance!(type)
          info = user_info
          return false if info.nil? || info.key?(:error)
          case type
          when 'buy'
            info[:balances][:USD].to_f <= trade.order_price
          when 'sell'
            info[:balances][:BTC].to_f.zero?
          end
        end

        # Возвращает баланс аккаунта
        #
        def user_info
          Services::Exmo::UserInfo.new(trade.key, trade.secret).user_info
        end
      end
    end
  end
end
