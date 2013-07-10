require 'test_helper'

class TweetTest < ActionDispatch::IntegrationTest
  def create_and_log_in
    user = FactoryGirl.create(:user_1) 
    visit root_path
    click_on 'Zaloguj'
    fill_in 'Adres e-mail', with: 'ktos@cos.pl' 
    fill_in 'Hasło', with: '1'
    click_button 'Zaloguj'
    user
  end

  def create_and_visit_tweet
    tweet = user.tweets.build(status: "Taki sobie tweet", current: true, version: 1)
    visit root_path
    click_on 'ktos@cos.pl'
    click_on 'Taki sobie tweet'
    tweet
  end

  test "save & show tweet" do
    user = create_and_log_in    
    visit root_path
    click_on 'Dodaj wpis'
    fill_in 'Status', with: 'Taki sobie tweet' 
    click_on 'Dodaj'
    assert has_content?('ktos@cos.pl: Taki sobie tweet')
  end
  
  test "edit tweet" do
    user = create_and_log_in 
    create_and_visit_tweet
    click_on 'Edytuj'
    fill_in 'Status', with: 'Taki'
    click_on 'Dodaj'
    assert has_content?('1: Taki sobie tweet')
    assert has_content?('2: Taki sobie tweet')
  end
end