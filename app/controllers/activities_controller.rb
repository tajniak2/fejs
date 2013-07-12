class ActivitiesController < ApplicationController
  def index
    @activities = Activity.from_friends(current_user)
  end
end
