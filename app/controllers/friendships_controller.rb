class FriendshipsController < ApplicationController
  def create
    @friendship = current_user.friendships.build(friend_id: params[:friend_id])
    if @friendship.save
      flash[:notice] = "Wysłano zaproszenie"
      redirect_to root_url
    else
      flash[:error] = "Coś nie tak..."
      redirect_to root_url
    end
  end

  def destroy
    @friendship = current_user.friendships.find(params[:id])
    @friendship.destroy
    flash[:notice] = "Nie jesteście już friendami"
    redirect_to current_user
  end

  #def feed
  #  @tweets = Tweets.from_friens(current_user)
  #end
  
  #def index
  #  @user = current_user
  #  @users = current_user.requests
  #end
  
  #def accept
  #  ship = Friendship.find_all_by_userA_id(params[:userB_id]).find_by_userB_id(current_user.id)
  #  ship.accepted = true
  # ship.save
  #  ship = Friendship.new(userA_id: current_user.id, userB_id: params[:userB_id], accepted: true)
  #end
end
