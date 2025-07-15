class AddUserDetailsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :last_name, :string, null: false
    add_column :users, :first_name, :string, null: false
    add_column :users, :last_name_kana, :string, null: false
    add_column :users, :first_name_kana, :string, null: false
    add_column :users, :phone_number, :string, null: false
    add_column :users, :birth_date, :date, null: false
    add_column :users, :gender, :integer, null: false
    add_column :users, :prefecture, :string, null: false
  end
end
