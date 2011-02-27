class CreatePersonalKeys < ActiveRecord::Migration
  def self.up
    create_table :personal_keys do |t|
      t.string :personal_key
      t.string :state
      t.integer :user_id

      t.timestamps
    end
    add_index :personal_keys, :user_id
  end

  def self.down
    drop_table :personal_keys
  end
end
