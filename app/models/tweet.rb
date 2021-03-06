﻿# == Schema Information
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
  
  default_scope -> { order('created_at desc') }
  scope :current, -> { where(current: true) }
  
  belongs_to :user
  
  validates :status, presence: true
  validates :version, presence: true
  # validates :current, presence: true - pod dodaniu tego wszystko się sypie :P
   
  def self.from_friends(user)
    friends_ids = Friendship.where(userA_id: user.id, accepted: true).map(&:userB_id)
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
    begin
      self.current = false
      tweet_new = user.tweets.create!(params) if status != params[:status]
      # tweet_new.version = self.version + 1
      # tweet_new.current = true
      # tweet_new.tweet_id = tweet_id
	  return tweet_new if self.save
      nil
    rescue ActiveRecord::RecordNotUnique
      self.version += 1
      self.status = params[:status]
      errors.add :base, "Wpis uległ zmianie podczas Twojej edycji."
      tweet_current = Tweet.where(version: version, tweet_id: tweet_id)[0]
      errors.add :base, "Obecna treść wpisu to #{tweet_current.status}"
      nil
    rescue ActiveRecord::RecordInvalid
      nil
    end
  end
  
  def hide
    self.current = false
    self.save
  end
  
  def revert(user, tweet_old)
    tweet = user.tweets.new({status: tweet_old.status, version: self.version + 1, current: true, tweet_id: tweet_id})
    self.current = false
	if tweet.save && self.save
      tweet
    else
      nil
    end
  end
end
