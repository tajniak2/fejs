class AddSeenFeedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :seen_feed, :datetime
  end
end
