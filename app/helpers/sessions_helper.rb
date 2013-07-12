module SessionsHelper
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def sign_in(id)
	session[:user_id] = id
  end
  
  def authorize
    redirect_to login_url, alert: "Nieutoryzowany dostęp" if current_user.nil?
  end
  
  def correct_user?(user)
    current_user == user
  end
  
end
