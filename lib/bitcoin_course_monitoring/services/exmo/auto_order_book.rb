# encoding: utf-8

module BitcoinCourseMonitoring
  module Services
    module Exmo
      # @author Алейников Максим <m.v.aleinikov@gmail.com>
      #
      # Класс возвращающий информацию по открытым ордерам
      #
      class AutoOrderBook
        PRICE_TREND_SIZE = 30

        SLOPE_TREND_SIZE = 3

        # Инициализирует клас объекта
        #
        def initialize
          @url = 'https://api.exmo.com/v1/order_book/'
          @price_trend = { ask: [], bid: [] }
          @slope_trend = { ask: [], bid: [] }
        end

        attr_reader :url, :price_trend, :slope_trend

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
              p slope_trend
              begin
                response =
                  RestClient.get(url, params: { limit: 1, pair: 'BTC_USD' }) { |resp, _request, _result| resp }
                order_book = JSON.parse(response.body, symbolize_names: true)
                unless order_book.key?(:error)
                  pair_orders = order_book[:BTC_USD]
                  $order_book = pair_orders
                  ask_top = pair_orders[:ask_top].to_f
                  bid_top = pair_orders[:bid_top].to_f
                  update_ask_price_trend(ask_top)
                  update_bid_price_trend(bid_top)
                  if ask_price_trend_is_full?
                    update_ask_slope_trend(slope(price_trend[:ask]))
                    $trend[:ask_slope] = positive_ask_slope_trend?
                  end
                  if bid_price_trend_is_full?
                    update_bid_slope_trend(slope(price_trend[:bid]))
                    $trend[:bid_slope] = negative_bid_slope_trend?
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

        def positive_ask_slope_trend?
          ask_slope_trend_is_full? && slope_trend[:ask].all?(&:positive?)
        end

        def negative_bid_slope_trend?
          bid_slope_trend_is_full? && slope_trend[:bid].all?(&:negative?)
        end

        def update_ask_slope_trend(ask_slope)
          return if slope_trend[:ask].last == ask_slope
          slope_trend[:ask].shift if ask_slope_trend_is_full?
          slope_trend[:ask].push(ask_slope)
        end

        def update_bid_slope_trend(bid_slope)
          return if slope_trend[:bid].last == bid_slope
          slope_trend[:bid].shift if bid_slope_trend_is_full?
          slope_trend[:bid].push(bid_slope)
        end

        def ask_slope_trend_is_full?
          slope_trend[:ask].size >= SLOPE_TREND_SIZE
        end

        def bid_slope_trend_is_full?
          slope_trend[:bid].size >= SLOPE_TREND_SIZE
        end

        def update_ask_price_trend(ask)
          return if price_trend[:ask].last == ask
          price_trend[:ask].shift if ask_price_trend_is_full?
          price_trend[:ask].push(ask)
        end

        def update_bid_price_trend(bid)
          return if price_trend[:bid].last == bid
          price_trend[:bid].shift if bid_price_trend_is_full?
          price_trend[:bid].push(bid)
        end

        def ask_price_trend_is_full?
          price_trend[:ask].size >= PRICE_TREND_SIZE
        end

        def bid_price_trend_is_full?
          price_trend[:bid].size >= PRICE_TREND_SIZE
        end

        def slope(trend)
          numbers_avg = numbers_average(trend)
          trend_size = trend.size
          (sum_of_multiplication(trend) - trend_size * numbers_avg * values_average(trend)) / (sum_of_squares_of_numbers(trend) - trend_size * numbers_avg ** 2)
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
      end
    end
  end
end
