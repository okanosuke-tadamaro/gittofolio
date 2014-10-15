class CreateScreenshots < ActiveRecord::Migration
  def change
    create_table :screenshots do |t|
      t.references :repository, index: true

      t.timestamps
    end
  end
end
