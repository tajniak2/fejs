class TweetsController < ApplicationController
  before_filter :correct_user, only: [:destroy, :edit, :update]

  def index
    @tweets = Tweet.all
  end
  
  def show
    @user = User.find(params[:user_id])
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
      @tweet.save
      flash[:succes] = "Wpis został zapisany"
      redirect_to current_user
    else
      render 'new'
    end
  end
  
  def destroy
    @tweet = Tweet.find(params[:id])
    @tweet.current = false
    if @tweet.save
      flash[:succes] = "Ok"
      redirect_to current_user
    else
      flash[:error] = "Źle"
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
	@tweet_new = @user.tweets.new(params[:tweet])
	@tweet.current = false
	if @tweet.status != params[:tweet][:status] && @tweet.save && @tweet_new.save
	  redirect_to [@user, @tweet_new]
	else
	  flash.now[:error] = "Niedokonano żadnej zmiany " + params[:tweet].to_s + " " + @tweet.current.to_s + " " + @tweet_new.current.to_s
	  render 'edit'
	end
  end
  
  private
  
    def correct_user
	  if current_user.id != params[:user_id].to_i
        redirect_to root_path, alert: "Nie możesz usuwać lub edytować cudzych wpisów"
	  end
    end
end
