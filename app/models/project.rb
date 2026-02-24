class Project < ApplicationRecord
  belongs_to :user
  has_many :conversations, dependent: :destroy

  validates :name, presence: true
end
