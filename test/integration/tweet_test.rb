﻿require 'test_helper'

class TweetTest < ActionDispatch::IntegrationTest
  def setup
    @user = FactoryGirl.create(:user_1)
    @tweet = @user.tweets.build(status: "Taki sobie tweet", current: true, version: 1, tweet_id: 1)
    @tweet.save
  end

  def log_in
    visit root_path
    click_on 'Zaloguj'
    fill_in 'Adres e-mail', with: 'ktos@cos.pl' 
    fill_in 'Hasło', with: '1'
    click_button 'Zaloguj'
  end

  test "save & show tweet" do
    log_in    
    visit root_path
    click_on 'Dodaj wpis'
    fill_in 'Status', with: 'Taki sobie tweet' 
    click_on 'Dodaj'
    assert has_content?('ktos@cos.pl: Taki sobie tweet')
  end
  
  test "edit tweet" do
    log_in 
    visit(user_tweet_path(@user, @tweet))
    click_on 'Edytuj'
    fill_in 'Status', with: 'Taki'
    click_on 'Dodaj'
    assert has_content?('1: Taki sobie tweet'), "luck of 1: Taki sobie tweet after editing tweet"
    assert has_content?('2: Taki'), "luck of 2: Taki after editing tweet"
  end
  
  test "does old tweet disappear" do
    visit(user_path(@user))
    assert !has_content?('Taki sobie tweet'), "edited tweets does not disappear"
  end
end