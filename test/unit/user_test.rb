# == Schema Information
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
#    user1 = Factory(:user_1)
#	user2 = Factory(:user_1)
#	user1.save
#	assert !user2.save, "no uniqness"
  end
  
  test "registration" do
	visit root_url
	click_on "Zarejestruj"
	fill_in 'email', with: '1@1.pl' 
	fill_in 'password', with: '1'
	fill_in 'password_confirmation', with: '1'
	click_on "Utwórz konto"
	assert has_content?('1@1.pl')
  end
  
end
