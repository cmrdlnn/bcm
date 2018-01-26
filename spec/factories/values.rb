# encoding: utf-8

# @author Алейников Максим <m.v.aleinikov@gmail.com>
#
# Фабрика значений
#

FactoryGirl.define do
  sequence(:uniq)

  # Строки
  #
  factory :string do
    transient do
      length nil
    end

    skip_create
    initialize_with { format("%0#{length}d", generate(:uniq).to_s) }
  end
end
