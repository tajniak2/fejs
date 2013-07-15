class TweetsController < ApplicationController
  before_filter :correct_user, only: [:destroy, :edit, :update]

  def index
    @tweets = Tweet.all
  end
  
  def show
    @user = User.find(params[:user_id])
    @tweet = Tweet.find(params[:id])
    @tweets = Tweet.where(tweet_id: @tweet.tweet_id)
  end
  
  def new
    @user = User.find(params[:user_id])
    @tweet = @user.tweets.new
  end
  
  def create
    @user = User.find(params[:user_id])
    @tweet = @user.tweets.new(params[:tweet])
    if @tweet.save_new
      track_activity @tweet
      flash[:succes] = "Wpis został zapisany"
      redirect_to current_user
    else
      render 'new'
    end
  end
  
  def destroy
    @tweet = Tweet.find(params[:id])
    if @tweet.hide
      track_activity @tweet
      flash[:succes] = "Wpis został usunięty"
      redirect_to current_user
    else
      flash[:error] = "Wpis nie został usunięty"
      render 'show'
    end
  end
  
  def edit
    @user = User.find(params[:user_id])
    @tweet = Tweet.find(params[:id])
  end
  
  def update
    @user = User.find(params[:user_id])
    @tweet = Tweet.find(params[:id])
    @tweet_new = @tweet.save_update(@user, params[:tweet])
	if @tweet_new
      track_activity @tweet_new
      redirect_to [@user, @tweet_new]
	else
      flash.now[:error] = "Niedokonano żadnej zmiany"
      render 'edit'
	end
  end
  
  def revert
    @tweet = Tweet.find(params[:tweet_id])
    @tweet_old = Tweet.find(params[:revert_id])
    @tweet_new = @tweet.revert(current_user, @tweet_old)
    track_activity @tweet_new
    redirect_to [current_user, @tweet_new]
  end
  
  private
  
    def correct_user
	  if current_user.id != params[:user_id].to_i
        redirect_to root_path, alert: "Nie możesz usuwać lub edytować cudzych wpisów"
	  end
    end
end
