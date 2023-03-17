class RemoveRequireRole < ActiveRecord::Migration[7.0]
  def change
    remove_column :posts, :require_role, :integer
  end
end
