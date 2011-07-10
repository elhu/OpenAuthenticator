class AddLoginUniquenessToUser < ActiveRecord::Migration
  def self.up
    add_index :users, :login, {:name => :login_index, :unique => true}
    add_index :users, :email, {:name => :email_index, :unique => true}
  end

  def self.down
    remove_index :users, :login
    remove_index :users, :email
  end
end
