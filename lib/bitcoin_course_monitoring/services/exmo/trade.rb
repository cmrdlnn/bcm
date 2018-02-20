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

        def initialize(trade)
          @key = trade.key
          p key
          @secret = trade.secret
          p secret
          @trade_id = trade.id
          @pair = trade.pair
          @order_price = trade.order_price
          @min = $order_book[:ask_top].to_f
          @max = $order_book[:bid_top].to_f
          @start_course = trade.start_course
          @stage = 1
        end

        attr_reader :order_price, :start_course, :trade_id, :pair, :key, :secret

        attr_reader :order_id

        attr_reader :stage

        def start
          Thread.new do
            loop do
              ask = $order_book[:ask_top].to_f
              p "ask: #{ask}"
              p "start_course: #{start_course}"
              if ask <= start_course && positive_ask_slope?
                buy(ask)
                launch_trade
                break
              end
              sleep 1
            end
          end
        end

        def launch_trade
          loop do
            if trend_is_filled?
              break if Models::Trade.with_pk(trade_id).closed
              case stage
              when 1
                ask = $order_book[:ask_top].to_f
                p "ask: #{ask}"
                p "Падение цены: #{start_course - ask}"
                buy(ask) if positive_ask_slope?
              when 2
                check_buy_order
              when 3
                bid = $order_book[:bid_top].to_f
                profit = profit(bid)
                p "bid: #{bid}"
                p "Прибыль: #{profit}"
                sell(bid) if profit.positive? && negative_bid_slope?
              when 4
                check_sell_order
              end
            end
            sleep 1
          end
        end

        private

        def check_buy_order
          order = Models::Order.with_pk(order_id)
          if order.state == 'error'
            @stage = 1
          elsif order.amount.zero? && Time.now - order.created_at > 180
            order.cancel_order
            @stage = 1
          elsif order.amount.positive?
            @start_course = order.price
            @stage = 3
          end
        end

        def check_sell_order
          order = Models::Order.with_pk(order_id)
          if order.state == 'error'
            @stage = 3
          elsif order.amount.zero? && Time.now - order.created_at > 180
            order.cancel_order
            @stage = 3
          elsif order.amount.positive?
            @start_course = order.price
            @stage = 1
          end
        end

        def buy(ask)
          price = ask + 0.00000001
          quantity = (order_price.to_f / price).ceil(8)
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
            Models::Order.where(trade_id: trade_id, type: 'buy').order(:created_at).last.amount
          quantity = (amount * 0.998).ceil(8)
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

        def trend_is_filled?
          !$trend.values.all?(&:nil?)
        end

        def positive_ask_slope?
          ask_slope = $trend[:ask_slope]
          ask_slope && ask_slope.positive?
        end

        def negative_bid_slope?
          bid_slope = $trend[:bid_slope]
          bid_slope && bid_slope.negative?
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
            trade_id: trade_id
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
            info[:balances][:USD].to_f <= order_price
          when 'sell'
            info[:balances][:BTC].to_f.zero?
          end
        end

        # Возвращает баланс аккаунта
        #
        def user_info
          Services::Exmo::UserInfo.new(key, secret).user_info
        end
      end
    end
  end
end
