class TweetsController < ApplicationController
  before_filter :correct_user, only: [:destroy, :edit, :update]

  def index
    @tweets = Tweet.all
  end
  
  def show
    @tweet = Tweet.find(params[:id])
	@tweets = Tweet.find_all_by_tweet_id(@tweet.tweet_id)
  end
  
  def new
    @user = User.find(params[:user_id])
    @tweet = @user.tweets.new
  end
  
  def create
    @user = User.find(params[:user_id])
    @tweet = @user.tweets.new(params[:tweet])
    if @tweet.save
      @tweet.tweet_id = @tweet.id
      flash[:succes] = "Wpis został zapisany"
      redirect_to current_user
    else
      render 'new'
    end
  end
  
  def destroy
    Tweet.find(params[:id]).current = false
    redirect_to current_user
  end
  
  def edit
    @tweet = Tweet.find(params[:id])
  end
  
  def update
    @tweet = Tweet.find(params[:id])
	if @tweet.status == params[:tweet][:status]
	  @tweet.current = false
	  @tweet_new = Tweet.create(params[:tweet])
	else
	  render 'edit'
	end
  end
  
  private
  
    def correct_user
      redirect_to root_path, alert: "Nie możesz usuwać lub edytować cudzych wpisów" if current_user != params[:user_id]
    end
end
