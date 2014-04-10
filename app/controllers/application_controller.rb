class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  private

  def current_user
  	if session[:github_access_token]
  		User.find_by(github_access_token: session[:github_access_token])
  	else
  		nil
  	end
  end

  def client
  	Octokit::Client.new(access_token: session[:github_access_token])
  end

end
