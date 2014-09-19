class CreateWebsites < ActiveRecord::Migration
  def change
    create_table :websites do |t|
      t.string :url
      t.integer :call_count
      t.references :user, index: true

      t.timestamps
    end
  end
end
