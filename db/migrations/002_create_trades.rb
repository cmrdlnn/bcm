# encoding: utf-8

# @author Алейников Максим <m.v.aleinikov@gmail.com>
#
# Создание таблицы торгов

Sequel.migration do
  change do
    create_table(:trades) do
      primary_key :id

      column :key, :text, null: false
      column :secret, :text, null: false
      column :start_course, :float, null: false, default: 0
      column :margin, :float, null: false
      column :order_price, :float, null: false
      column :closed, :boolean, null: false, default: false
      column :created_at, :timestamp, index: true, null: false

      foreign_key :user_id,  :users,
                  type:      :integer,
                  null:      false,
                  index:     true,
                  on_update: :cascade,
                  on_delete: :cascade
    end
  end
end
