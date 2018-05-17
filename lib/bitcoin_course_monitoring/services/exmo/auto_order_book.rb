# encoding: utf-8

module BitcoinCourseMonitoring
  module Services
    module Exmo
      # @author Алейников Максим <m.v.aleinikov@gmail.com>
      #
      # Класс возвращающий информацию по открытым ордерам
      #
      class AutoOrderBook
        class << self
          attr_accessor :pairs
        end

        PRICE_TREND_SIZE = 30

        SLOPE_TREND_SIZE = 7

        URL = 'https://api.exmo.com/v1/order_book/'.freeze

        # Инициализирует клас объекта
        #
        def initialize(initial_pairs)
          @price_trend = {}
          @slope_trend = {}
          self.class.pairs = initial_pairs
          update_pairs_in_trends
        end

        # Запускает поток с get запросом на апи биржи
        # и получает данные по открытым ордерам каждую секунду
        # обновляя каждый раз глобальную переменную
        #
        #
        def order_book
          Thread.new do
            loop do
              sleep 1
              p $trend
              update_pairs_in_trends if price_trend.keys != pairs
              begin
                response =
                  RestClient.get(URL, params: params) { |resp, _request, _result| resp }
                order_book = JSON.parse(response.body, symbolize_names: true)
                unless order_book.key?(:error)
                  pairs.each do |pair|
                    pair_orders = order_book[pair].transform_values do |val|
                      val.is_a?(String) ? val.to_f : val
                    end
                    ask_top = pair_orders[:ask_top]
                    bid_top = pair_orders[:bid_top]
                    update_price_trend(ask_top, pair, :ask)
                    update_price_trend(bid_top, pair, :bid)
                    update_order_book(pair_orders, pair)
                  end
                end
              rescue => e
                error = "#{e.class}: #{e.message}:\n  #{e.backtrace.first}"
                $logger.error { error }
                { error: error }
              end
            end
          end
        end

        private

        attr_reader :price_trend, :slope_trend

        def update_order_book(pair_orders, pair)
          $order_book[pair] = pair_orders unless $order_book[pair]
          bid = pair_orders[:bid].map { |order| order.first.to_f }
          average = bid.inject(0.0) { |sum, price| sum + price } / bid.size
          current_bid_top = $order_book[pair][:bid_top]
          if (average - pair_orders[:bid_top]).abs / current_bid_top > 0.05
            $order_book[pair] = pair_orders.merge(bid_top: bid.max)
          else
            $order_book[pair] = pair_orders
          end
        end

        def update_pairs_in_trends
          pairs.each do |pair|
            next if price_trend[pair]
            price_trend[pair] = { ask: [], bid: [] }
            slope_trend[pair] = { ask: [], bid: [] }
          end
        end

        def update_price_trend(value, pair, type)
          trend = price_trend[pair][type]
          return if trend.last == value
          trend.push(value)
          return unless price_trend_is_full?(trend)
          trend.shift
          update_slope_trend(trend, pair, type)
        end

        def price_trend_is_full?(trend)
          trend.size > PRICE_TREND_SIZE
        end

        def update_slope_trend(trend, pair, type)
          slope_value = slope(trend)
          selected_slope_trend = slope_trend[pair][type]
          return if selected_slope_trend.last == slope_value
          selected_slope_trend.push(slope_value)
          return unless slope_trend_is_full?(selected_slope_trend)
          selected_slope_trend.shift
          update_global_trend(selected_slope_trend, pair, type)
        end

        def slope_trend_is_positive?(trend)
          trend.all?(&:positive?)
        end

        def slope_trend_is_negative?(trend)
          trend.all?(&:negative?)
        end

        def slope_trend_is_full?(trend)
          trend.size > SLOPE_TREND_SIZE
        end

        def update_global_trend(trend, pair, type)
          $trend[pair] = { ask_slope: false, bid_slope: false } unless $trend[pair]
          $trend[pair][:"#{type}_slope"] = if type == :ask
                                             slope_trend_is_positive?(trend)
                                           else
                                             slope_trend_is_negative?(trend)
                                           end
        end

        def slope(trend)
          numbers_avg = numbers_average(trend)
          trend_size = trend.size
          (sum_of_multiplication(trend) - trend_size * numbers_avg * values_average(trend)) /
            (sum_of_squares_of_numbers(trend) - trend_size * numbers_avg ** 2)
        end

        def numbers_average(trend)
          (trend.size + 1) / 2.to_f
        end

        def values_average(trend)
          trend.reduce(:+) / trend.size.to_f
        end

        def sum_of_squares_of_numbers(trend)
          trend_size = trend.size
          trend_size * (trend_size + 1) * (2 * trend_size + 1) / 6.to_f
        end

        def sum_of_multiplication(trend)
          trend.each_with_index.inject(0) do |sum, (val, i)|
            sum + (val * (i + 1))
          end
        end

        def pairs
          self.class.pairs
        end

        def params
          { limit: 3, pair: pairs.join(',') }
        end
      end
    end
  end
end
