class CreateConversations < ActiveRecord::Migration[8.1]
  def change
    create_table :conversations do |t|
      t.string :title
      t.string :session_key
      t.integer :status
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
