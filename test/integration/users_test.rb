require 'test_helper'

class UsersTest < ActionDispatch::IntegrationTest
  test "registration" do
    visit root_path
    click_on 'Zarejestruj'
    fill_in 'Adres e-mail', with: '1@1.pl' 
    fill_in 'Hasło', with: '1'
    fill_in 'Potwierdzenie hasła', with: '1'
    click_on 'Utwórz konto'
    assert has_content?('1@1.pl')
  end
  
  test "log in" do
    user = FactoryGirl.create(:user1) # Nie działa Factory. Why?
    user.save
    visit root_path
    click_on 'Zaloguj'
    fill_in 'Adres e-mail', with: 'ktos@cos.pl' 
    fill_in 'Hasło', with: '1'
    click_button 'Zaloguj'
    assert has_content?('Zalogowany jako ktos@cos.pl')
  end
  
  test "save tweet" do
    user = FactoryGirl.create(:user1) # Nie działa Factory. Why?
    user.save
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
  
  test "show user" do
    user = FactoryGirl.create(:user1) # Nie działa Factory. Why?
    user.save
    visit root_path
    click_on 'Zaloguj'
    fill_in 'Adres e-mail', with: 'ktos@cos.pl' 
    fill_in 'Hasło', with: '1'
    click_button 'Zaloguj'
    click_on 'Strona główna'
    click_on 'ktos@cos.pl'
    assert_equal user_path(user), current_path, "diffrent paths"
    assert has_content?('ktos@cos.pl'), "don't have ktos@cos.pl"
  end
end
