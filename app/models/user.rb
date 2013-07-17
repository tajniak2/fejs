# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  password_digest :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  seen_feed       :datetime
#  admin           :boolean          default(FALSE)
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
  
  before_create :set_seen_feed
  
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
  
  def update_seen_feed
    self.seen_feed = Time.now
    self.save
  end
  
  def set_seen_feed
    self.seen_feed = Time.now
  end
  
  def update_user(params, user)
    if user.admin?
      return false if params[:admin] == '0' && self == user && User.where(admin: true).count == 1
      self.admin = params[:admin]
    end       
    params_new = params.permit(:email, :password, :password_confrimation)
    self.update_attributes(params_new)
    self.save
  end
end
