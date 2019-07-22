class Invite < ApplicationRecord
  attr_accessor :emails

  belongs_to :conference

  validates :end_date, presence: true
  validates :content, presence: true
  validates :user_id, presence: true

end
