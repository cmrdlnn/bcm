# encoding: utf-8

# @author Алейников Максим <m.v.aleinikov@gmail.com>
#
# Создание таблицы учетных записей пользователей

Sequel.migration do
  change do
    create_enum :role_type, %i(administrator trader)

    create_table(:users) do
      primary_key :id

      column :login, :text, null: false, unique: true
      column :role, :role_type, index: true, null: false
      column :first_name, :text, null: false
      column :last_name, :text
      column :salt, :bytea
      column :password_hash, :bytea
    end
  end
end
