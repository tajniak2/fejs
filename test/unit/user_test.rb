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

﻿# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
#  test "uniqness of user" do
#    user1 = FactoryGirl.create(:user_1)
#	user2 = FactoryGirl.create(:user_1)
#	user1.save
#	assert !user2.save, "no uniqness"
#  end
 
end
