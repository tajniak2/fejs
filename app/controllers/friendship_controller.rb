class FriendshipController < ApplicationController
  def feed
    @tweets = Tweets.from_friens(current_user)
  end
  
  def index
    @user = current_user
    @users = current_user.friend_requests
  end
  
  def accept
    ship = Friendship.find_all_by_userA_id(params[:userB_id]).find_by_userB_id(current_user.id)
    ship.accepted = true
    ship.save
    ship = Friendship.new(userA_id: current_user.id, userB_id: params[:userB_id], accepted: true)
  end
end
