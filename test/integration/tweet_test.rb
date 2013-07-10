require 'test_helper'

class TweetTest < ActionDispatch::IntegrationTest
  test "save & show tweet" do
    user = FactoryGirl.create(:user_1)
    visit root_path
    click_on 'Zaloguj'
    fill_in 'Adres e-mail', with: 'ktos@cos.pl' 
    fill_in 'Hasło', with: '1'
    click_button 'Zaloguj'
    
    visit root_path
    click_on 'Dodaj wpis'
    fill_in 'Status', with: 'Taki sobie tweet' 
    click_on 'Dodaj'
    assert has_content?('ktos@cos.pl: Taki sobie tweet')
  end  
end