class AddIndexedToPseudoCookie < ActiveRecord::Migration
  def self.up
    add_index :pseudo_cookies, :cookie, :unique => true
    add_index :pseudo_cookies, :user_id, :unique => true
  end

  def self.down
  end
end
