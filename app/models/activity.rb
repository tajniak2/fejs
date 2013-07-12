class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :trackable, polymorphic: true
  attr_accessible :action, :trackable
  
  def self.from_friends(user)
    friends_ids = Friendship.where(userA_id: user.id, accepted: true).map(&:userB_id)
    where("user_id IN (?) OR user_id = ?", friends_ids, user.id).order("created_at desc")
  end
end
