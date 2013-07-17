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
      flash[:success] = "Użykownik zarejestrowany"
	  sign_in @user.id
      redirect_to @user
    else
      flash[:error] = "Niepoprawny e-mail lub hasło"
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Zmieniono ustawienia użytkownika"
      render 'show'
    else
      flash[:error] = "Coś poszło nie tak"
      render 'edit'
    end
  end
end
