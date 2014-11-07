class UsersController < ApplicationController
  
	before_action :signed_in?
	before_action :check_user

  def show
  	@user = current_user
  	@repos = @user.repositories.order(:display).reverse
  	@website = @user.websites.new
  end

end
