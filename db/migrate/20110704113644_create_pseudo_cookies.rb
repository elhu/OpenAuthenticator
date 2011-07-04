class CreatePseudoCookies < ActiveRecord::Migration
  def self.up
    create_table :pseudo_cookies do |t|
      t.integer :user_id
      t.string :cookie
      t.datetime :expire

      t.timestamps
    end
  end

  def self.down
    drop_table :pseudo_cookies
  end
end
