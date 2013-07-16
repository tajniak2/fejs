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

class Tweet < ActiveRecord::Base
  attr_accessible :status, :version, :current, :tweet_id, :original_updated_at
  
  default_scope order('created_at desc')
  scope :current, where(current: true)
  
  belongs_to :user
  
  validates :status, presence: true
  validates :version, presence: true
  # validates :current, presence: true - pod dodaniu tego wszystko się sypie :P
   
  def self.from_friends(user)
    friends_ids = Friendship.find_all_by_userA_id_and_accepted(user.id, true).map(&:userB_id)
    where("user_id IN (?) OR user_id = ?", friends_ids, user.id)
  end
  
  def save_new
    self.version = 1
    self.current = true
    if self.save
      self.tweet_id = id
      self.save
    else
      false
    end
  end
  
  def save_update(user, params)
    tweet_new = user.tweets.new(params)
    tweet_new.version = params[:version] #self.version + 1
    tweet_new.current = true
    tweet_new.tweet_id = tweet_id
	self.current = false
	if status != params[:status] && tweet_new.save && self.save
      tweet_new
    else
      nil
    end
  rescue ActiveRecord::RecordNotUnique
    self.version += 1
    self.status = params[:status]
    errors.add :base, "Wpis uległ zmianie podczas Twojej edycji."
    tweet_current = Tweet.where(version: version, tweet_id: tweet_id)[0]
    errors.add :base, "Obecna treść wpisu to #{tweet_current.status}"
    nil
  end
  
  def hide
    self.current = false
    self.save
  end
  
  def revert(user, tweet_old)
    tweet = user.tweets.new
    tweet.status = tweet_old.status
    tweet.version = version + 1
    tweet.current = true
    tweet.tweet_id = tweet_id
    self.current = false
	if tweet.save && self.save
      tweet
    else
      nil
    end
  end
end
