module TweetsHelper
  def can_revert?(tweet)
    allow?(:tweets, :revert, current_resource) && tweet != @tweet
  end
  
  def current_resource
    @current_resource ||= Tweet.find(params[:id]) if params[:id]
  end  
end
