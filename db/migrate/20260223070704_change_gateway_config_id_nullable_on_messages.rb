class ChangeGatewayConfigIdNullableOnMessages < ActiveRecord::Migration[8.1]
  def change
    change_column_null :messages, :gateway_config_id, true
  end
end
