class UsersController < ApplicationController
  
	before_action :signed_in?
	before_action :check_user

  def show
  	@website = current_user.websites.new
  	@websites = current_user.websites
  	@repositories = current_user.repositories
  	
  end

end
