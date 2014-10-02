class UsersController < ApplicationController
  
	before_action :signed_in?
	before_action :check_user

  def show
  	@website = current_user.websites.new
  	@websites = current_user.websites
  	@repositories = Repository.where(owner: current_user.login)
  end

end
