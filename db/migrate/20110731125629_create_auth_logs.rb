class CreateAuthLogs < ActiveRecord::Migration
  def self.up
    create_table :auth_logs do |t|
      t.integer :account_token_id
      t.boolean :outcome

      t.timestamps
    end
  end

  def self.down
    drop_table :auth_logs
  end
end
