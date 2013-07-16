class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  
  before_filter :authorize
    
  delegate :allow?, to: :current_permission
  helper_method :allow?

  delegate :allow_param?, to: :current_permission
  helper_method :allow_param?

  private

  def current_permission
    @current_permission ||= Permission.new(current_user)
  end
  
  def current_resource
    nil
  end

  def authorize
    if current_permission.allow?(params[:controller], params[:action], current_resource)
      current_permission.permit_params! params
    else
      redirect_to root_url, alert: "Nieautoryzowany dostęp"
    end
  end
 
  def track_activity(trackable, action = params[:action])
    current_user.activities.create! action: action, trackable: trackable
  end
end
