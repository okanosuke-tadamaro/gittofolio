class UserHasManyDetails < ActiveRecord::Migration
  def change
  	add_reference :details, :user, index: true
  end
end