class CreateScreenshots < ActiveRecord::Migration
  def change
    create_table :screenshots do |t|
      t.string :original_url
      t.references :repository, index: true

      t.timestamps
    end
  end
end
