class UsersController < ApplicationController
  skip_before_filter :authorize, only: [:index, :new, :create]
  
  def index
    @users = User.all
    # @users.each do |user|
        # if Friendship.find_by_userA_id_and_userB_id(current_user.id, user.id) || current_user == user
            # user.can_be_added? = true
        # end
    # end
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
  
  def add_friend
    @user = User.find(params[:id])
    current_user.friends << @user
    flash[:success] = "Zaproszenie zostało wysłanie"
    render 'show'
  end
  
  def del_friend
    @user = User.find(params[:id])
    current_user.friends.destroy(@user)
    flash[:success] = "Przestaliście być przyjaciółmi"
    render 'show'
  end
  
  #def destroy
  #def edit
  #def update
  
end
