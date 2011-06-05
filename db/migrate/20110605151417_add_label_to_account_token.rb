class AddLabelToAccountToken < ActiveRecord::Migration
  def self.up
    add_column :account_tokens, :label, :string
  end

  def self.down
    remove_column :account_tokens, :label
  end
end
