class AddEnumToUsersAndPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :visibility, :integer
    add_column :users, :role, :integer
  end
end
