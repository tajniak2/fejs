# == Schema Information
#
# Table name: tweets
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  status     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  verison    :integer
#  current    :boolean
#

class Tweet < ActiveRecord::Base
  attr_accessible :status, :veriosn, :current
  has_many :tweets
  
  scope :current, where(current: true)
  
  belongs_to :user
  belongs_to :tweet, dependent: :destroy
  
  validates :status, presence: true
  validates :veriosn, presence: true
  validates :current, presence: true
end
