# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  password_digest :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  version         :integer
#  current         :boolean
#

class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation
  has_secure_password
  has_many :tweets
  
  has_many :friendships, foreign_key: "userA_id"
  has_many :friends, through: :friendships, source: :userA
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "userB_id"
  has_many :requests, through: :inverse_friendships, source: :userA
  
  scope :friends_requests, includes(:requests).where(requests: {accepted: false})
  
  validates :email, presence: true, uniqueness: true
  
end
