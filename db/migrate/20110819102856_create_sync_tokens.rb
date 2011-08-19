class CreateSyncTokens < ActiveRecord::Migration
  def self.up
    create_table :sync_tokens do |t|
      t.integer :user_id
      t.string :sync_token
      t.datetime :expires_at
      t.boolean :used, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :sync_tokens
  end
end
