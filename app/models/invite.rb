class Invite < ApplicationRecord
  belongs_to :conference

  validates :end_date, presence: true
  validate :content, presence: true
  validate :user_id
  
end
