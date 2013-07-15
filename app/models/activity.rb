# == Schema Information
#
# Table name: activities
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  action         :string(255)
#  trackable_id   :integer
#  trackable_type :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :trackable, polymorphic: true
  attr_accessible :action, :trackable
  
  def self.from_friends(user)
    friends_ids = Friendship.where(userA_id: user.id, accepted: true).map(&:userB_id)
    where("user_id IN (?) OR user_id = ?", friends_ids, user.id).order("created_at desc")
  end
end
