module TweetsHelper
  def can_revert?(tweet)
    correct_user?(@user) && tweet != @tweet
  end
  
  def current_resource
    @current_resource ||= Tweet.find(params[:id]) if params[:id]
  end  
end
