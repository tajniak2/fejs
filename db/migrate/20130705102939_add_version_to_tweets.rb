class AddVersionToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :version, :integer
	add_column :tweets, :current, :boolean
  end
end
