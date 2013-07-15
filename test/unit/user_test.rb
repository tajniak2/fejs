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

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user_1 = FactoryGirl.create(:user_0)
    @user_2 = FactoryGirl.create(:user_0)
  end
 
  test "after sending request there is record in database" do
    status = @user_1.add_or_accept_friend(@user_2.id)
    assert status[0] == 1, "there is wrong status (" + status.to_s + ")"
    assert Friendship.where(userA_id: @user_1.id, userB_id: @user_2.id, accepted: false) != [], "there is no correct record in db"
    assert Friendship.where(userA_id: @user_2.id, userB_id: @user_1.id) == [], "there is symetrical relation in db"
  end
  
  test "after accepting request there is record in database" do
    @user_1.add_or_accept_friend(@user_2.id)
    status =  @user_2.add_or_accept_friend(@user_1.id)
    assert status[0] == 2, "there is wrong status (" + status.to_s + ")"
    assert Friendship.where(userA_id: @user_2.id, userB_id: @user_1.id, accepted: true) != [], "there is no correct record in db"
    assert Friendship.where(userA_id: @user_1.id, userB_id: @user_2.id, accepted: true) != [], "there is no symetrical relation in db"
  end
end
