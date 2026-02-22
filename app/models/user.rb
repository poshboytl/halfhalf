class User < ApplicationRecord
  has_secure_password
  has_many :gateway_configs, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, on: :create
end
