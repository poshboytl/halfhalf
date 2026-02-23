class CreateToolCalls < ActiveRecord::Migration[8.1]
  def change
    create_table :tool_calls do |t|
      t.references :conversation, null: false, foreign_key: true
      t.references :message, null: false, foreign_key: true
      t.string :tool_name
      t.text :input
      t.text :output
      t.integer :status

      t.timestamps
    end
  end
end
