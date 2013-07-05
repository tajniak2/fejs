class AddBelongsToTweetToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :tweet, :belongs_to
  end
end
