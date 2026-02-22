class GatewayConfig < ApplicationRecord
  belongs_to :user
  encrypts :api_token

  validates :name, presence: true
  validates :endpoint, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }
  validates :api_token, presence: true
end
