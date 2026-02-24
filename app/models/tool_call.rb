class ToolCall < ApplicationRecord
  belongs_to :conversation
  belongs_to :message, optional: true

  enum :status, { pending: 0, running: 1, completed: 2, failed: 3 }

  validates :tool_name, presence: true
end
