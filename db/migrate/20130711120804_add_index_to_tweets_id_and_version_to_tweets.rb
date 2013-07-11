class AddIndexToTweetsIdAndVersionToTweets < ActiveRecord::Migration
  def change
    add_index :tweets, [:tweet_id, :version], unique: true
  end
end
