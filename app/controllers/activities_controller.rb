class ActivitiesController < ApplicationController
  after_filter :update_date
  
  def index
    @activities = Activity.from_friends(current_user).includes(:user, :trackable)
  end
  
  def index_admin
    @activities = Activity.all.includes(:user, :trackable)
  end
  
  private

    def update_date
      current_user.update_seen_feed
      true
    end
end
