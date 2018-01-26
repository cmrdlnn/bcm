# encoding: utf-8

# @author Алейников Максим <m.v.aleinikov@gmail.com>
#
# Создание таблицы учетных записей администраторов

Sequel.migration do
  change do
    create_table(:admins) do
      primary_key :id

      column :login, :text, null: false, unique: true
      column :name, :text, null: false
      column :salt, :bytea, null: false
      column :password_hash, :bytea, null: false
    end
  end
end
