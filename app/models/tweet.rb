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
  attr_accessible :status, :version, :current, :tweet_id
  
  default_scope order('created_at desc')
  scope :current, where(current: true)
  
  belongs_to :user
  
  validates :status, presence: true
  validates :version, presence: true
  # validates :current, presence: true
  # validates :tweet_id, presence: true
  
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
    tweet_new.version = version + 1
    tweet_new.current = true
    tweet_new.tweet_id = tweet_id
	self.current = false
	if status != params[:status] && tweet_new.valid? && self.save && tweet_new.save
      tweet_new
    else
      nil
    end
  end
end
