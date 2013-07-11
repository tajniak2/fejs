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
    @user_1 = FactoryGirl.create(:user_0)
    @user_2 = FactoryGirl.create(:user_0)
    @tweet = @user.tweets.build(status: "Fajny status")
    @tweet_2 = @user.tweets.build(status: "Fajny tweet")
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
  
  test "sending empty tweet should fail" do
    @tweet_2.save_new
    tweet_new = @tweet_2.save_update(@user, {status: ""} )
    tweet_old = Tweet.find(@tweet_2.id)
    assert tweet_old.current, "Old tweet has been hidden"
  end
  
  test "after calling from_friends it should show all friends' posts" do
    tweet_1 = @user_1.tweets.new(status: "Cool")
    tweet_2 = @user_2.tweets.new(status: "Cool story bro")
    tweet_3 = @user.tweets.new(status: "Cool story")
    tweet_1.save_new
    tweet_2.save_new
    tweet_3.save_new
    Friendship.create(userA_id: @user_1.id, userB_id: @user_2.id, accepted: true)
    Friendship.create(userA_id: @user_2.id, userB_id: @user_1.id, accepted: true)
    friends_tweets = Tweet.from_friends @user_1
    assert friends_tweets.include?(tweet_1), "it doesn't show user_1 tweet"
    assert friends_tweets.include?(tweet_2), "it doesn't show user_2 tweet"
    assert !friends_tweets.include?(tweet_3), "it does show user tweet"
  end
  
  test "sending two tweets with the same tweet_id and version should fail" do
    tweet_1 = @user.tweets.new(status: "Cool story", version: 6, tweet_id: 23)
    tweet_2 = @user.tweets.new(status: "Not cool story bro", version: 6, tweet_id: 23)
    tweet_1.save
    assert_raise(ActiveRecord::RecordNotUnique) { tweet_2.save }
  end
  
  test "deleting tweet should ony hide it" do
    @tweet.save_new
    tweet_id = @tweet.id
    @tweet.hide
    assert Tweet.find(tweet_id), "tweet has been removed"
    assert !@tweet.current, "tweet hasn't been hidden"
  end
end
