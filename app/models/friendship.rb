class Friendship < ActiveRecord::Base
  attr_accessible :userA_id, :userB_id, :accepted
  
  belongs_to :userA, class_name: "User"
  # belongs_to :userB_id, class_name: "User"
 
  validates :userA_id, presence: true
  validates :userB_id, presence: true, exclusion: { in: [:userA_id] }
end
