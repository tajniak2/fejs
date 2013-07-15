# == Schema Information
#
# Table name: friendships
#
#  id         :integer          not null, primary key
#  userA_id   :integer
#  userB_id   :integer
#  accepted   :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Friendship < ActiveRecord::Base
  attr_accessible :userA_id, :userB_id, :accepted
  
  belongs_to :userA, class_name: "User"
  belongs_to :userB, class_name: "User" 
  
  validate :friendship_validator
 
  validates :userA_id, presence: true
  validates :userB_id, presence: true
  
  def friendship_validator
     errors.add(:userB_id, "can't be friend with yourself") if userA_id == userB_id
  end
end
