class AddVersionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :version, :integer
	add_column :users, :current, :boolean
  end
end
