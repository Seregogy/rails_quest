class Mission < ApplicationRecord
  belongs_to :agent

  validates :title, presence: true
  validates :status, presence: true

  enum :status, {
    assigned: "assigned",
    in_process: "in_progress",
    complete: "completed"
  }
end
