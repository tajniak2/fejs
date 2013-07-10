module UsersHelper
    def can_be_added?(added, current)
        current.nil? and (added != current) and !Friendship.where(userA_id: current.id, userB_id: added.id)
    end
end
