module TweetsHelper
  def can_revert?(tweet)
    allow?(:tweets, :revert, current_resource) && tweet != @tweet
  end
end
