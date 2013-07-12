require 'test_helper'

class ActivityTest < ActionDispatch::IntegrationTest
  def setup
    @user = FactoryGirl.create(:user_1)
  end
  
  def log_in
    visit root_path
    click_on 'Zaloguj'
    fill_in 'Adres e-mail', with: 'ktos@cos.pl' 
    fill_in 'Has³o', with: '1'
    click_button 'Zaloguj'
  end
  

end