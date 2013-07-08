# == Schema Information
#
# Table name: tweets
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  status     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  verison    :integer
#  current    :boolean
#

class Tweet < ActiveRecord::Base
  attr_accessible :status, :version, :current, :tweet_id
  
  scope :current, where(current: true)
  
  belongs_to :user
  
  validates :status, presence: true
  validates :version, presence: true
  # validates :current, presence: true
  # validates :tweet_id, presence: true
  
  def self.from_friens(user)
    friends_ids = user.friends.map(&:id)
    where("user_id IN (?) OR user_id = ?", friends_ids, user)
  end
end
