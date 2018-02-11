# encoding: utf-8

module BitcoinCourseMonitoring
  module Services
    module Exmo
      # @author Алейников Максим <m.v.aleinikov@gmail.com>
      #
      # Класс возвращающий информацию по крсу валютных пар
      #
      class Trade
        COMMISSION = 0.002

        URL = 'https://api.exmo.com/v1'.freeze

        PAIR = :BTC_USD

        def initialize
          @margin = 0.02
          @order_price = 10
          book = order_book
          @min = book[:ask_top].to_f
          @max = book[:bid_top].to_f
          @start_course = min
        end

        attr_reader :margin, :order_price, :start_course

        attr_reader :max, :min

        attr_reader :bought

        def start
          Thread.new do
            loop do
              book = order_book
              bid = book[:bid_top].to_f
              ask = book[:ask_top].to_f
              if bought
                p "bid: #{bid}"
                if bid >= max
                  @max = bid
                elsif start_course != max && (max - bid) / (max - start_course) <= 0.02
                  @bought = false
                  @start_course = ask
                  @min = ask
                  p "SELL! #{bid - 0.000001}"
                end
              else
                p "ask: #{ask}"
                if ask <= min
                  @min = ask
                elsif start_course == min && ask > min
                  @bought = true
                  @start_course = bid
                  @max = bid
                  p "BUY! #{ask + 0.000001}"
                elsif start_course != min && (ask - min) / (start_course - min) >= 0.02
                  @bought = true
                  @start_course = bid
                  @max = bid
                  p "BUY! #{ask + 0.000001}"
                end
              end
              sleep 1
            end
          end
        end

        def order_book
          request('order_book', pair: 'BTC_USD')
        end

        def pair_settings
          request('pair_settings')
        end

        def request(to = '', params)
          response = RestClient.get("#{URL}/#{to}", params: params)
          parse(response.body)[PAIR]
        end

        def parse(json)
          JSON.parse(json, symbolize_names: true)
        end

        Trade.new.start
      end
    end
  end
end
