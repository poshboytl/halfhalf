class CreateProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :workspace_path
      t.string :repo_url
      t.text :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
