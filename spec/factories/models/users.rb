# encoding: utf-8

# @author Алейников Максим <m.v.aleinikov@gmail.com>
#
# Фабрика записей учетных записей администратора
#

FactoryGirl.define do
  factory :user, class: BitcoinCourseMonitoring::Models::User do
    login         { create(:string) }
    role          {'trader'}
    salt          { SecureRandom.random_bytes(32) }
    password_hash { SecureRandom.random_bytes(32) }
    created_at    { Time.now }
  end
end
