class AddVersionToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :verison, :integer
	add_column :tweets, :current, :boolean
	remove_column :users, :verison
	remove_column :users, :verison
  end
end
