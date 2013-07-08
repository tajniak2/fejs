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
  has_many :friends, through: :friendship, foreign_key: :userA, source: :userB
  has_many :requests, through: :friendship, foreign_key: :userB, source: :userA
  
  scope :friends_requests, requests.where("accepted: false")
  
  validates :email, presence: true, uniqueness: true
end
