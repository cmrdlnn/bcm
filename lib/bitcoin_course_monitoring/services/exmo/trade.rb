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

        TREND_SIZE = 30

        def initialize(trade)
          @key = trade.key
          @secret = trade.secret
          @trade_id = trade.id
          @pair = trade.pair
          @margin = trade.margin
          @order_price = trade.order_price
          @min = $order_book[:ask_top].to_f
          @max = $order_book[:bid_top].to_f
          @trend = [min]
          @start_course = trade.start_course
        end

        attr_reader :margin, :order_price, :start_course, :trade_id, :pair, :key, :secret

        attr_reader :max, :min

        attr_reader :bought, :trend

        def start
            loop do
              brake if Models::Trade.with_pk(trade_id).closed
              book = $order_book[:BTC_USD]
              bid = book[:bid_top].to_f
              ask = book[:ask_top].to_f
              if bought
                p "bid: #{bid}"
                p "Прибыль: #{profit(bid)}"
                @max = bid if bid > max
                update_trend(bid) if bid != trend.last
                profit = profit(bid)
                if profit.positive? && !positive_slope?\
                # if profit.positive? && downtrend? && (max - bid) / (max - start_course.to_f) >= 0.2\
                  p "profit: #{profit}"
                  @bought = false
                  @min = ask
                  @trend = [ask]
                  @start_course = ask
                  price = bid - 0.000001
                  quantity = balance[:BTC]
                  type = 'sell'
                  create_data = create_order_data(price, quantity, type)
                  next if check_balance!(type)
                  order = Models::Order.create(create_data)
                  p "SELL! #{bid - 0.000001} #{order.state}"
                end
              else
                p "ask: #{ask}"
                p "Падение цены: #{start_course - ask}"
                @min = ask if ask < min
                update_trend(ask) if ask != trend.last
                if positive_slope?
                  @bought = true
                  @max = bid
                  @trend = [bid]
                  @start_course = ask + 0.000001
                  price = ask + 0.000001
                  quantity = order_price.to_f / price * (1 + COMMISSION)
                  type = 'buy'
                  create_data = create_order_data(price, quantity, type)
                  next if check_balance!(type)
                  order = Order.create(create_data)
                  p "BUY! #{ask + 0.000001} #{order.state}"
                end
              end
              sleep 1
            end
        end

        private

        def slope
          numbers_avg = numbers_average
          trend_size = trend.size
          (sum_of_multiplication - trend_size * numbers_avg * values_average) /
            (sum_of_squares_of_numbers - trend_size * numbers_avg ** 2)
        end

        def profit(bid)
          (1 - COMMISSION) * bid - (1 + COMMISSION) * start_course.to_f
        end

        def update_trend(new_price)
          trend.shift if trend_is_full?
          trend.push(new_price)
        end

        def numbers_average
          (trend.size + 1) / 2.to_f
        end

        def values_average
          trend.reduce(:+) / trend.size.to_f
        end

        def sum_of_squares_of_numbers
          trend_size = trend.size
          trend_size * (trend_size + 1) * (2 * trend_size + 1) / 6.to_f
        end

        def sum_of_multiplication
          trend.each_with_index.inject(0) do |sum, (val, i)|
            sum + (val * (i + 1))
          end
        end

        def positive_slope?
          p slope
          return unless trend_is_full?
          slope > 0
        end

        def trend_is_full?
          trend.size >= TREND_SIZE
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
            balance[:balances][:BTC].to_f = 0
          end
        end

        # Возвращает баланс аккаунта
        #
        def balance
          balance = Services::Exmo::UserInfo.new(key, secret).user_info
        end
      end
    end
  end
end
