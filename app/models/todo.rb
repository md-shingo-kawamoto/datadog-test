class Todo < ApplicationRecord
  validates :title, presence: true, length: { maximum: 200 }
  validates :description, length: { maximum: 1000 }
  
  scope :completed, -> { where(completed: true) }
  scope :incomplete, -> { where(completed: false) }
  scope :recent, -> { order(created_at: :desc) }
end

