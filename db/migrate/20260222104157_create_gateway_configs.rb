class CreateGatewayConfigs < ActiveRecord::Migration[8.1]
  def change
    create_table :gateway_configs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :endpoint
      t.text :api_token

      t.timestamps
    end
  end
end
