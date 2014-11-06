class UsersController < ApplicationController
  
	before_action :signed_in?
	before_action :check_user

  def show
  	@user = current_user
  	@website = @user.websites.new
  end

end
