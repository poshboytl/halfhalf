class Message < ApplicationRecord
  belongs_to :gateway_config, optional: true  # 向后兼容，后续移除
  belongs_to :conversation, optional: true
  has_many :tool_calls, dependent: :destroy

  enum :role, { user: "user", assistant: "assistant", system: "system" }
  enum :status, { pending: 0, streaming: 1, completed: 2, failed: 3 }

  validates :role, presence: true
  validates :content, presence: true, if: -> { user? }

  scope :ordered, -> { order(created_at: :asc) }
end
