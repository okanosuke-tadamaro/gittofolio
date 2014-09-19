class UsersController < ApplicationController
  
	before_action :signed_in?

  def show
  	@website = current_user.websites.new
  	@websites = current_user.websites
  end

end
