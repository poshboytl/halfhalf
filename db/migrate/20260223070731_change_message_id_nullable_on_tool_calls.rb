class ChangeMessageIdNullableOnToolCalls < ActiveRecord::Migration[8.1]
  def change
    change_column_null :tool_calls, :message_id, true
  end
end
