class AddProfiletoUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :likes, :string
    add_column :users, :dislikes, :string
    add_column :users, :about, :string
  end
end
