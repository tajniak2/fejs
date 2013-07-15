module TweetsHelper
  def can_revert?(tweet)
    correct_user?(@user) && tweet != @tweet
  end
end
