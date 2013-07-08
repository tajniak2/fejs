class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.integer :userA_id
      t.integer :userB_id
      t.boolean :accepted, default: false

      t.timestamps
    end
    
    add_index :friendships, :userA_id
    add_index :friendships, :userB_id
    add_index :friendships, [:userA_id, :userB_id], unique: true
  end
end
