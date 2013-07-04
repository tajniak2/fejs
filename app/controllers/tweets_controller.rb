class TweetsController < ApplicationController
  def index
    @tweets = Tweet.all
  end
  
  def show
    @tweet = Tweet.find(params[:id])
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
  
  #def destroy
  #def edit
  #def update  
end
