class ChangeStringToText < ActiveRecord::Migration[7.0]
  def change
    change_column :posts, :content, :text
    change_column :comments, :comment, :text
    change_column :users, :about, :text
  end
end
