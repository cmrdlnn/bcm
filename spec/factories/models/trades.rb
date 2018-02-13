# encoding: utf-8

# @author Алейников Максим <m.v.aleinikov@gmail.com>
#
# Фабрика записей торгов
#

FactoryGirl.define do
  factory :trade, class: BitcoinCourseMonitoring::Models::Trade do
    key         { create(:string) }
    secret      { create(:string) }
    pair        { 'BTC_USD' }
    margin      { 0.04 }
    order_price { 0.3 }
    created_at  { Time.now }

    association :user
  end
end
