require 'test_helper'

class FriendshipTest < ActionDispatch::IntegrationTest
  def log_in(email)
    visit root_path
    click_on 'Zaloguj'
    fill_in 'Adres e-mail', with: email 
    fill_in 'Hasło', with: '1'
    click_button 'Zaloguj'
  end

  test "add friend" do
    user_1 = FactoryGirl.create(:user_0)
    user_2 = FactoryGirl.create(:user_0)
    log_in user_1.email
    visit root_path
    click_link 'Dodaj znajomego'
    assert has_content?('Wysłano zaproszenie'), "invitation hasn't been sent"
  end
end