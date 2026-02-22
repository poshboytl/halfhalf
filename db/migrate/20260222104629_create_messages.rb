class CreateMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :messages do |t|
      t.references :gateway_config, null: false, foreign_key: true
      t.string :role
      t.text :content
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
