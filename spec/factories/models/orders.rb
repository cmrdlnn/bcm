# encoding: utf-8

# @author Алейников Максим <m.v.aleinikov@gmail.com>
#
# Фабрика записей ордеров
#

FactoryGirl.define do
  factory :order, class: BitcoinCourseMonitoring::Models::Order do
    type        { 'buy' }
    pair        { 'BTC_USD' }
    quantity    { 0.04 }
    price       { 0.3 }
    order_id    { 12 }
    created_at  { Time.now }

    association :trade
  end
end
