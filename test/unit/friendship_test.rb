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

require 'test_helper'

class FriendshipTest < ActiveSupport::TestCase
  test "forever alone (ability of being friend with yourself)" do
    friendship = Friendship.new(userA_id: 1, userB_id: 1)
    assert !friendship.valid?
  end
end
