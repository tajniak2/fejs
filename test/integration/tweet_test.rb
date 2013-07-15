require 'test_helper'

class TweetTest < ActionDispatch::IntegrationTest
  def setup
    @user = FactoryGirl.create(:user_1)
    @user_1 = FactoryGirl.create(:user_0)
    @tweet_1 = @user.tweets.build(status: "Taki sobie tweet", current: true, version: 1, tweet_id: 1)
    @tweet_1.save
    @tweet_2 = @user.tweets.build(status: "Jakiś tweet", current: true, version: 1)
    @tweet_3 = @user_1.tweets.build(status: "Fajny tweet", current: true, version: 1)
  end

  def log_in
    visit root_path
    click_on 'Zaloguj'
    fill_in 'Adres e-mail', with: 'ktos@cos.pl' 
    fill_in 'Hasło', with: '1'
    click_button 'Zaloguj'
  end

  test "after sending tweet user should see it" do
    log_in    
    visit root_path
    click_on 'Dodaj wpis'
    fill_in 'Status', with: 'Taki sobie tweet' 
    click_on 'Dodaj'
    assert has_content?('ktos@cos.pl: Taki sobie tweet')
  end
  
  test "after editing tweet, on tweet's page should appear new and old version" do
    log_in 
    visit(user_tweet_path(@user, @tweet_1))
    click_on 'Edytuj'
    fill_in 'Status', with: 'Taki'
    click_on 'Dodaj'
    assert has_content?('1: Taki sobie tweet'), "luck of 1: Taki sobie tweet after editing tweet"
    assert has_content?('2: Taki'), "luck of 2: Taki after editing tweet"
  end
  
  test "after editing only new version of tweet should be shown" do
    visit(user_path(@user))
    assert !has_content?('Taki sobie tweet'), "edited tweets does not disappear"
  end
  
  test "deleted tweets does not appear in user's tweets" do
    @tweet_2.save
    log_in
    visit(user_path(@user))
    click_on 'Jakiś tweet'
    click_on 'Usuń'
    visit(user_path(@user))
    assert !has_content?('Jakiś tweet'), "deleted tweets does not disappear"
  end
  
  test "after clicik on revert old tweet should be reverted" do
    log_in 
    visit(user_tweet_path(@user, @tweet_1))
    click_on 'Edytuj'
    fill_in 'Status', with: 'Taki'
    click_on 'Dodaj'
    click_on 'Przywróć'
    assert has_content?('1: Taki sobie tweet'), "luck of 1: Taki sobie tweet after editing tweet"
    assert has_content?('2: Taki'), "luck of 2: Taki after editing tweet"
    assert has_content?('3: Taki sobie tweet'), "luck of 3: Taki sobie tweet after editing tweet"
  end
  
  test "if editing of other user's tweets is diabled" do
    log_in 
    @tweet_3.save
    visit(user_tweet_path(@user_1, @tweet_3))
    assert !has_link?('Edytuj'), "there is editing link"
  end
end