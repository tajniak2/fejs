require 'test_helper'

class UsersTest < ActionDispatch::IntegrationTest
  def setup
    @user = FactoryGirl.create(:user_1)
  end

  def log_in
    visit root_path
    click_on 'Zaloguj'
    fill_in 'Adres e-mail', with: 'ktos@cos.pl' 
    fill_in 'Hasło', with: '1'
    click_button 'Zaloguj'
  end

  test "after registration user should be shown in User's controller index" do
    visit root_path
    click_on 'Zarejestruj'
    fill_in 'Adres e-mail', with: '1@1.pl' 
    fill_in 'Hasło', with: '1'
    fill_in 'Potwierdzenie hasła', with: '1'
    click_on 'Utwórz konto'
    assert has_content?('1@1.pl')
  end
  
  test "after loging in user should see info that he/she is logged in" do
    log_in
    assert has_content?('Zalogowany jako ktos@cos.pl')
  end
  
  test "clicking user's link on root page should redirect to user's page" do
    log_in
    click_on 'Strona główna'
    click_on 'ktos@cos.pl'
    assert_equal user_path(@user), current_path, "diffrent paths"
    assert has_content?('ktos@cos.pl'), "don't have ktos@cos.pl"
  end
  
  test "after loging out user should see link to log in" do
    log_in
    click_on 'Wyloguj'
    assert has_content?('Zaloguj'), "loging out does not work"
  end
end
