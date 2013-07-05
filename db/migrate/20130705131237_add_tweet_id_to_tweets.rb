class AddTweetIdToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :tweet_id, :integer
    remove_column :tweets, :tweet
  end
end
