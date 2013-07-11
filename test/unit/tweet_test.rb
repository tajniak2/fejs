# == Schema Information
#
# Table name: tweets
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  status     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  version    :integer
#  current    :boolean
#  tweet_id   :integer
#

require 'test_helper'

class TweetTest < ActiveSupport::TestCase
  def setup
    @user = FactoryGirl.create(:user_1)
    @tweet = @user.tweets.build(status: "Fajny status")
  end

  test "if save_new method saves tweet properly" do
    @tweet.save_new
    tweet_db = Tweet.find(@tweet.id)
    assert_equal 1, tweet_db.version, "tweet's version set incorrectly"
    assert_equal @tweet.id, tweet_db.tweet_id, "tweet's id set incorrectly"
    assert tweet_db.current, "tweet's current set incorrectly"
  end
  
  test "if save_update method updates tweet properly" do
    @tweet.save_new
    tweet_new = @tweet.save_update(@user, {status: "Fajny"} )
    assert_equal "Fajny", tweet_new.status, "tweet_new's status set incorrectly"
    assert_equal @tweet.version + 1, tweet_new.version, "tweet_ne's version set incorrectly"
    assert_equal @tweet.tweet_id, tweet_new.tweet_id, "tweet_new's id set incorrectly"
    assert tweet_new.current, "tweet_new's current set incorrectly"
    assert !@tweet.current, "old tweet's current set incorrectly"
  end
end
