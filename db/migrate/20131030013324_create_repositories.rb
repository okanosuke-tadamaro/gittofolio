class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :name
      t.text :description
      t.string :language
      t.string :owner
      t.string :avatar
      t.string :full_name
      t.string :location
      t.string :company
      t.string :blog
      t.string :homepage
      t.boolean :fork
      t.date :start_date
      t.date :update_date

      t.timestamps
    end
  end
end
