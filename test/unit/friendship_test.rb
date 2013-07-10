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
  # test "the truth" do
  #   assert true
  # end
end
