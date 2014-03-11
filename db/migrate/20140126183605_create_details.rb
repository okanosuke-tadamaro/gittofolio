class CreateDetails < ActiveRecord::Migration
  def change
    create_table :details do |t|
      t.string :user_name
      t.string :repo_name
      t.string :header
      t.text :body

      t.timestamps
    end
  end
end
