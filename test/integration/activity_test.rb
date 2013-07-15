require 'test_helper'

class ActivityTest < ActionDispatch::IntegrationTest
  def setup
    @user = FactoryGirl.create(:user_1)
    @user_1 = FactoryGirl.create(:user_0)
    @tweet = @user.tweets.new(status: "Fajny")
  end
  
  def log_in
    visit root_path
    click_on 'Zaloguj'
    fill_in 'Adres e-mail', with: 'ktos@cos.pl' 
    fill_in 'Hasło', with: '1'
    click_button 'Zaloguj'
  end
  
  test "adding tweet should show information about activity" do
    log_in    
    visit root_path
    click_on 'Dodaj wpis'
    fill_in 'Status', with: 'Taki sobie tweet' 
    click_on 'Dodaj'
    visit activities_path
    # save_and_open_page
    # within 'div#activity' do
    assert has_link?('ktos@cos.pl'), "there is no link to user"
    assert has_content?('utworzył nowy wpis Taki sobie tweet'), "there is no info"
  end
  
  test "editing tweet should show information about activity" do
    log_in
    @tweet.save_new
    visit(user_tweet_path(@user, @tweet))
    click_on 'Edytuj'
    fill_in 'Status', with: 'Taki2'
    click_on 'Dodaj'
    visit activities_path
    assert has_link?('ktos@cos.pl'), "there is no link to user"
    assert has_content?('zaktualizował wpis Taki2'), "there is no info"
  end
  
  test "deleting tweet should show information about activity" do
    log_in
    @tweet.save_new
    visit(user_tweet_path(@user, @tweet))
    click_on 'Usuń'
    visit activities_path
    assert has_link?('ktos@cos.pl'), "there is no link to user"
    assert has_content?('usunął wpis'), "there is no info"
  end
  
  test "sending request should show information about activity" do
    log_in
    click_on 'Dodaj znajomego'
    visit activities_path    
    assert has_link?('ktos@cos.pl'), "there is no link to user"
    assert has_content?('wysłał zaproszenie do'), "there is no info"
    assert has_link?(@user_1.email), "there is no link to invited user"
  end
end