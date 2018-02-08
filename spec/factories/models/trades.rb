# encoding: utf-8

# @author Алейников Максим <m.v.aleinikov@gmail.com>
#
# Фабрика записей учетных записей торгов
#

FactoryGirl.define do
  factory :trade, class: BitcoinCourseMonitoring::Models::Trade do
    key         { create(:string) }
    secret      { create(:string) }
    margin      { 0.04 }
    order_price { 0.3 }
    created_at  { Time.now }

    association :user
  end
end
