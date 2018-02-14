# encoding: utf-8

# @author Алейников Максим <m.v.aleinikov@gmail.com>
#
# Создание таблицы ордеров

Sequel.migration do
  change do
    create_enum :order_type, %i(buy sell)
    create_enum :state_type, %i(processing fulfilled canceled error)

    create_table(:orders) do
      primary_key :id

      column :type, :order_type, index: true, null: false
      column :pair, :text, null: false
      column :quantity, :float, null: false
      column :amount, :float
      column :price, :float, null: false
      column :order_id, :integer, index: true, null: false, default: 0
      column :state, :state_type, index: true, null: false, default: 'processing'
      column :created_at, :timestamp, index: true, null: false

      foreign_key :trade_id,  :trades,
                  type:      :integer,
                  null:      false,
                  index:     true,
                  on_update: :cascade,
                  on_delete: :cascade
    end
  end
end
