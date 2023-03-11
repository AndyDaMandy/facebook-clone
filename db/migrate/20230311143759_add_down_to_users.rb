class AddDownToUsers < ActiveRecord::Migration[7.0]
  def self.down
    remove_index  :users, :confirmation_token

    remove_column :users, :unconfirmed_email
    remove_column :users, :confirmation_sent_at
    remove_column :users, :confirmed_at
    remove_column :users, :confirmation_token
  end
end
