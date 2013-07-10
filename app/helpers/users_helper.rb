module UsersHelper
  def can_be_added?(added)
    current_user and (added != current_user) and !Friendship.where(userA_id: current_user.id, userB_id: added.id).exists?
  end
end
