class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :name
      t.text :description
      t.string :language
      t.string :owner
      t.string :avatar

      t.timestamps
    end
  end
end
