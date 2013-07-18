class Permission
  def initialize(user)
    allow :users, [:new, :create]
    allow :sessions, [:new, :create, :destroy]
    allow :tweets, [:index, :show]
    if user
      allow :users, [:show]
      allow :users, [:edit, :update] do |u|
        user == u
      end
      allow :tweets, [:new, :create]
      allow :tweets, [:edit, :update, :destroy] do |tweet|
        tweet.user_id == user.id
      end
      allow :tweets, [:revert] do |tweet|
        tweet.user_id == user.id
      end
      allow_param :tweet, [:status]
      allow_param :activity, [:user, :trackable]
      allow :activities, [:index]
      allow :friendships, [:feed, :index]
      allow :friendships, [:create, :destroy]
      allow_all if user.admin?
    end
  end
  
  def allow?(controller, action, resource = nil)
    allowed = @allow_all || @allowed_actions[[controller.to_s, action.to_s]]
    allowed && (allowed == true || resource && allowed.call(resource))
  end
  
  def allow_all
    @allow_all = true
  end
  
  def allow(controllers, actions, &block)
    @allowed_actions ||= {}
    Array(controllers).each do |controller|
      Array(actions).each do |action|
        @allowed_actions[[controller.to_s, action.to_s]] = block || true
      end
    end
  end

  def allow_param(resources, attributes)
    @allowed_params ||= {}
    Array(resources).each do |resource|
      @allowed_params[resource] ||= []
      @allowed_params[resource] += Array(attributes)
    end
  end

  def allow_param?(resource, attribute)
    if @allow_all
      true
    elsif @allowed_params && @allowed_params[resource]
      @allowed_params[resource].include? attribute
    end
  end

  def permit_params!(params)
    if @allow_all
      params.permit!
    elsif @allowed_params
      @allowed_params.each do |resource, attributes|
        if params[resource].respond_to? :permit
          params[resource] = params[resource].permit(*attributes)
        end
      end
    end
  end
end