class ActivityPresenter < SimpleDelegator
  attr_reader :activity
  
  def initialize(activity, view)
    super(view)
    @activity = activity
  end
  
  def render_activity
    div_for activity do
      link_to(activity.user.email, activity.user) + " " + render_partial + if_new
    end
  end
  
  def render_partial
    locals = {activity: activity, presenter: self}
    locals[activity.trackable_type.underscore.to_sym] = activity.trackable
    render partial_path, locals
  end
  
  def partial_path
    partial_paths.detect do |path|
      lookup_context.template_exists? path, nil, true
    end || raise("No partial found for activity in #{partial_paths}")
  end
  
  def partial_paths
    [
      "activities/#{activity.trackable_type.underscore}/#{activity.action}",
      "activities/#{activity.trackable_type.underscore}",
      "activities/activity"
    ]
  end
  
  def if_new
    " (nowe!)" if current_user.seen_feed.nil? || current_user.seen_feed < @activity.created_at
  end
end

