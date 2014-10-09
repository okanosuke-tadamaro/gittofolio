class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :login
      t.string :email
      t.string :avatar
      t.string :company
      t.string :location
      t.string :blog
      t.string :github_access_token

      t.timestamps
    end
  end
end
