class ActivitiesController < ApplicationController
  after_filter :update_date
  
  def index
    @activities = Activity.from_friends(current_user)
  end
  
  private

    def update_date
      current_user.update_seen_feed
      true
    end
end
