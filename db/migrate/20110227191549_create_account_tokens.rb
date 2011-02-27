class CreateAccountTokens < ActiveRecord::Migration
  def self.up
    create_table :account_tokens do |t|
      t.string :account_token
      t.string :state
      t.integer :user_id

      t.timestamps
    end
    add_index :account_tokens, :user_id
  end

  def self.down
    drop_table :account_tokens
  end
end
