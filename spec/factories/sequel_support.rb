# encoding: utf-8

# @author Алейников Максим <m.v.aleinikov@gmail.com>
#
# Поддержка Sequel в FactoryGirl
#

FactoryGirl.define do
  to_create(&:save)
end
