class AddDisplayToRepository < ActiveRecord::Migration
  def change
    add_column :repositories, :display, :boolean, default: false
  end
end
