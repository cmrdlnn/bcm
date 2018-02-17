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
          @secret = trade.secret
          @trade_id = trade.id
          @pair = trade.pair
          @order_price = trade.order_price
          @min = $order_book[:ask_top].to_f
          @max = $order_book[:bid_top].to_f
          @start_course = trade.start_course
        end

        attr_reader :order_price, :start_course, :trade_id, :pair, :key, :secret

        attr_reader :bought

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
              bid = $order_book[:bid_top].to_f
              ask = $order_book[:ask_top].to_f
              if bought
                p "bid: #{bid}"
                p "Прибыль: #{profit(bid)}"
                profit = profit(bid)
                sell(bid) if profit.positive? && negative_bid_slope?
              else
                p "ask: #{ask}"
                p "Падение цены: #{start_course - ask}"
                buy(ask) if positive_ask_slope?
              end
            end
            sleep 1
          end
        end

        private

        def buy(ask)
          @bought = true
          price = ask + 0.00000001
          @start_course = price
          quantity = order_price.to_f / price
          type = 'buy'
          create_data = create_order_data(price, quantity, type)
          return if check_balance!(type)
          order = Order.create(create_data)
          p "BUY! #{price}"
        end

        def sell(bid)
          p "profit: #{profit}"
          @bought = false
          @start_course = nil
          price = bid - 0.00000001
          quantity = balance[:BTC]
          type = 'sell'
          p create_data = create_order_data(price, quantity, type)
          return if check_balance!(type)
          order = Models::Order.create(create_data)
          p "SELL! #{price}"
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
          return false if balance.key?(:error)
          case type
          when 'buy'
            balance[:balances][:USD].to_f <= order_price
          when 'sell'
            balance[:balances][:BTC].to_f == 0
          end
        end

        # Возвращает баланс аккаунта
        #
        def balance
          Services::Exmo::UserInfo.new(key, secret).user_info
        end
      end
    end
  end
end
