﻿require 'test_helper'

class ActivityTest < ActionDispatch::IntegrationTest
  def setup
    @user = FactoryGirl.create(:user_1)
    @user_1 = FactoryGirl.create(:user_0)
    @tweet = @user.tweets.new(status: "Fajny")
  end
  
  def log_in(email = 'ktos@cos.pl')
    visit root_path
    click_on 'Zaloguj'
    fill_in 'Adres e-mail', with: email
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
  
  test "revervting tweet should show information about activity" do
    log_in
    @tweet.save_new
    visit(user_tweet_path(@user, @tweet))
    click_on 'Edytuj'
    fill_in 'Status', with: 'Taki2'
    click_on 'Dodaj'
    click_on 'Przywróć'
    visit activities_path
    assert has_link?('ktos@cos.pl'), "there is no link to user"
    assert has_content?('zaktualizował wpis Fajny, przywracając poprzednią wersję'), "there is no info"
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
  
  test "sending request and accepting it should show information about activity" do
    log_in
    click_on 'Dodaj znajomego'
    visit activities_path    
    assert has_link?('ktos@cos.pl'), "there is no link to user before accepting"
    assert has_content?('wysłał zaproszenie do ' + @user_1.email), "there is no info before accepting"
    assert has_link?(@user_1.email), "there is no link to invited user before accepting"
    click_on 'Wyloguj'
    log_in @user_1.email
    click_on 'Akceptuj zaproszenie'
    visit activities_path
    assert has_link?('ktos@cos.pl'), "there is no link to user after accepting"
    assert has_content?('zaakceptował zaproszenie od ' + @user.email), "there is no info about accepting after it"
    assert has_content?('wysłał zaproszenie do ' + @user_1.email), "there is no info about sending request after accepting"
    assert has_link?(@user_1.email), "there is no link to invited user"
  end
  
  test "new activity should be marked as new and after seeing it it should be marked as read" do
    log_in
    click_on 'Dodaj znajomego'
    visit activities_path
    assert has_content?('nowe!'), "no info about new activity"
    visit activities_path
    assert !has_content?('nowe!'), "info about new activity hasn't disappeared"
  end
end