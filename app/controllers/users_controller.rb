class UsersController < ApplicationController
  skip_before_filter :authorize, only: [:index, :new, :create]
  
  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
	@tweets = @user.tweets.current
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:succes] = "Użykownik zarejestrowany"
	  sign_in @user.id
      redirect_to @user
    else
      flash[:error] = "Niepoprawny e-mail lub hasło"
      render 'new'
    end
  end
  
  #def destroy
  #def edit
  #def update
  
end
