require 'test_helper'

class FriendshipTest < ActionDispatch::IntegrationTest
  def setup
    @user_1 = FactoryGirl.create(:user_0)
    @user_2 = FactoryGirl.create(:user_0)
    @tweet = @user_1.tweets.build(status: "Taki sobie tweet", current: true, version: 1, tweet_id: 1)
  end

  def log_in(email)
    visit root_path
    click_on 'Zaloguj'
    fill_in 'Adres e-mail', with: email 
    fill_in 'Hasło', with: '1'
    click_button 'Zaloguj'
  end

  test "after sending invitation user should see info that invitation has been sent" do
    log_in @user_1.email
    visit root_path
    click_link 'Dodaj znajomego'
    assert has_content?('Wysłano zaproszenie'), "invitation hasn't been sent"
  end
  
  test "after accepting invitation user should see tweets of new friend" do
    @user_1.add_or_accept_friend(@user_2.id)
    log_in @user_2.email
    click_link 'Akceptuj zaproszenia'
    click_link 'Akceptuj'
    click_link 'Aktualności'
    assert has_content?('ktos1@cos.pl: Taki sobie tweet'), "user_1's tweet not in user_1's feed"
  end
end