class SessionsController < ApplicationController
  skip_before_filter :authorize, only: [:new, :create]
  
  def new
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user && @user.authenticate(params[:password])
      sign_in @user.id
      flash[:success] = "Zalogowany"
      redirect_to root_url
    else
	  if @user
        flash.now[:error] = 'E-mail ok'
	  else
	    flash.now[:error] = 'E-mail nieok'
	  end
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
	flash[:success] = "Wylogowany"
    redirect_to root_url
  end
end
