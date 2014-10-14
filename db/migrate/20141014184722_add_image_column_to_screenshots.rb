class AddImageColumnToScreenshots < ActiveRecord::Migration
  def self.up
  	add_attachment :screenshots, :image
  end

  def self.down
  	remove_attachment :screenshots, :image
  end
end
