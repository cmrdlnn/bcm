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

        def initialize(trade, course, stage = 1, remainder = 0, order_id = 0)
          @trade = trade
          @pair = trade.pair.to_sym
          @start_course = course
          @stage = stage
          @remainder = remainder
          @order_id = order_id
        end

        attr_reader :start_course

        attr_reader :trade, :pair

        attr_reader :order_id

        attr_reader :stage

        attr_reader :remainder

        # Запускает механизм торгов
        def start
          Thread.new do
            loop do
              sleep 1
              break if trade_closed?
              next unless $order_book[pair] && $trend[pair]
              ask = $order_book[pair][:ask_top]
              p "ask: #{ask}"
              p "start_course: #{start_course}"
              if ask <= start_course && $trend[pair][:ask_slope]
                buy(ask)
                launch_trade
                break
              end
            end
          end
        end

        # Выполняет мониторинг ордеров на покупку и на продажу создает
        # и отменяет их в зависимости от выполненных условий
        def launch_trade
          loop do
            sleep 1
            break if trade_closed?
            next unless $order_book[pair] && $trend[pair]
            case stage
            when 1
              ask = $order_book[pair][:ask_top]
              p "ask: #{ask}"
              p "Падение цены: #{start_course - ask}"
              buy(ask) if $trend[pair][:ask_slope]
            when 2
              check_buy_order
            when 3
              bid = $order_book[pair][:bid_top]
              ask = $order_book[pair][:ask_top]
              profit = profit(bid)
              p "bid: #{bid}"
              p "Прибыль: #{profit}"
              sell(bid) if price_drop?(ask) ||
                           profit.positive? && $trend[pair][:bid_slope]
            when 4
              check_sell_order
            end
          end
        end

        private

        # Проверяет было или нет падение цены
        #
        # @params [Float] ask
        #  текущая цена
        # @return [Boolean]
        #  результат проверки
        def price_drop?(ask)
          order = Models::Order.with_pk(order_id)
          slump?(order, ask, 0.95, 300) || slump?(order, ask, 0.9, 36_000)
        end

        # Проверяет было или нет резкое падение цены
        #
        # @params [Float] ask
        #  текущая цена
        # @params [Models::Order] order
        #  текущий ордер
        # @return [Boolean]
        #  результат проверки
        def slump?(order, price, proportion, time)
          (order.price * proportion) > ask && Time.now - time > order.created_at
        end

        # Проверяет закрыты или нет текущие торги
        #
        # @return [Boolean]
        #  результат проверки
        def trade_closed?
          Models::Trade.with_pk(trade.id).closed
        end

        # Проверяет состояние ордера на покупку и выполняет операции
        # в зависимости от условий
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

        # Проверяет состояние ордера на продажу и выполняет операции
        # в зависимости от условий
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

        # Создает ордер на покупку
        #
        # @params [Float] ask
        #  текущая цена целевой валюты
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

        # Создает ордер на продажу
        #
        # @params [Float] bid
        #  текущая цена целевой валюты
        def sell(bid)
          p "profit: #{profit(bid)}"
          price = bid - 0.00000001
          amount =
            Models::Order.where(trade_id: trade.id, type: 'buy').order(:created_at).last.amount
          quantity =
            @remainder.zero? ? (amount * 0.998).floor(8) : remainder
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

        # Высчитывает профит
        #
        # @params [Float] bid
        #  текущая цена целевой валюты
        # @return [Float]
        #  профит
        def profit(bid)
          bid - start_course.to_f / (1 - COMMISSION) - bid * COMMISSION
        end

        # Подготавливает данные для создания ордера
        #
        # @param [Float] price
        #  цена за еденицу
        # @param [Float] quantity
        #  количество
        # @param [String] type
        #  тип ордера
        # @return [Hash]
        #  данные для создания ордера
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
        def check_balance!(type)
          info = user_info
          pair = trade.pair.split('_')
          return false if info.nil? || info.key?(:error)
          case type
          when 'buy'
            info[:balances][pair[1].to_sym].to_f <= trade.order_price
          when 'sell'
            info[:balances][pair[0].to_sym].to_f.zero?
          end
        end

        # Возвращает баланс аккаунта
        def user_info
          Services::Exmo::UserInfo.new(trade.key, trade.secret).user_info
        end
      end
    end
  end
end
