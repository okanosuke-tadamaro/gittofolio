class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.integer :repo_id
      t.string :name
      t.text :description
      t.string :language
      t.string :homepage
      t.boolean :fork
      t.date :start_date
      t.date :update_date
      t.references :user, index: true

      t.timestamps
    end
  end
end
