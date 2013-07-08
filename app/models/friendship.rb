class Friendship < ActiveRecord::Base
  attr_accessible :userA_id, :userB_id, :accepted
  
  belongs_to :userA_id, class_name: "User"
  belongs_to :userB_id, class_name: "User"
 
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
