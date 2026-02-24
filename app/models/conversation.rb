class Conversation < ApplicationRecord
  belongs_to :project
  has_many :messages, dependent: :destroy
  has_many :tool_calls, dependent: :destroy

  enum :status, { active: 0, archived: 1 }

  validates :title, presence: true

  before_create :generate_session_key

  private

  def generate_session_key
    self.session_key ||= "halfhalf:conv:#{SecureRandom.uuid}"
  end
end
