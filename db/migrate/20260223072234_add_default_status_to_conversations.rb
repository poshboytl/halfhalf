class AddDefaultStatusToConversations < ActiveRecord::Migration[8.1]
  def change
    # Set default for new records
    change_column_default :conversations, :status, from: nil, to: 0

    # Update existing records
    reversible do |dir|
      dir.up do
        execute "UPDATE conversations SET status = 0 WHERE status IS NULL"
      end
    end
  end
end
