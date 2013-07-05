class TweetsController < ApplicationController
  before_filter correct_user, only: [:destroy, :edit, :upadte] # Czemu nie działo before_save?

  def index
    @tweets = Tweet.all
  end
  
  def show
    @tweet = Tweet.find(params[:id])
	@tweets = @tweet.tweets
  end
  
  def new
    @tweet = current_user.tweets.build
  end
  
  def create
   @tweet = current_user.tweets.build(params[:tweet])
    if @tweet.save
      flash[:succes] = "Wpis został zapisany"
      redirect_to current_user
    else
      render 'new'
    end
  end
  
  def destroy
    Tweet.find(params[:id]).destroy
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
	  redirect_to root_path, alert: "Nie możesz usuwać lub edytować cudzych wpisów" if current_user != @tweet.user.id
    end
end
