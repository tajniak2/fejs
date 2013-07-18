class FriendshipsController < ApplicationController
  def create
    @status = current_user.add_or_accept_friend(params[:friend_id])
    if @status[0] == 1
      track_activity(@status[1], 'sent')
      flash[:success] = "Wysłano zaproszenie"
    elsif @status[0] == 2
      track_activity(@status[1], 'accepted')
      flash[:success] = "Zaakceptowano znajomość"
    else
      flash[:error] = "Coś poszło nie tak..."
    end
    redirect_to root_url 
  end

  def destroy
    @friendship = current_user.friendships.find(params[:id])
    @friendship.destroy
    flash[:notice] = "Nie jesteście już friendami"
    redirect_to current_user
  end

  def feed
    @tweets = Tweet.from_friends(current_user).includes(:user)
  end
  
  def index
    @user = current_user
    @users = current_user.requests
  end
end
