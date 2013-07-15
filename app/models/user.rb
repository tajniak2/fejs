# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  password_digest :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation
  has_secure_password
  has_many :tweets
  
  has_many :friendships, foreign_key: "userA_id"
  has_many :friends, through: :friendships, source: :userB_id, conditions: {friendships: {accepted: true}}
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "userB_id"
  has_many :requests, through: :inverse_friendships, source: :userA, conditions: {friendships: {accepted: false}}
  
  has_many :activities
  
  validates :email, presence: true, uniqueness: true
  
  def add_or_accept_friend(friend_id)
    # status: 0 - failed, 1 - added, 2 - accepted
    @status = 1
    @friendship = friendships.build(userB_id: friend_id)
    @friendship_rev = Friendship.where(userA_id: friend_id, userB_id: id)
    if @friendship_rev.exists?
      @friendship_rev[0].accepted = true
      @friendship_rev[0].save
      @friendship.accepted = true
      @status = 2
    end
    @status = 0 unless @friendship.save
    [@status, @friendship]
  end
end
