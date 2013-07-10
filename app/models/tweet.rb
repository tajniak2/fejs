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
end
