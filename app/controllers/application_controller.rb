class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :signed_in?, :check_user

  private

  def check_user_existence
    if !User.exists?(login: params[:user])
      render json: { status: false, msg: 'The requested user does not exists in our database' }
    end
  end

  def check_user
    redirect_to "/#{params[:user_name]}" if params[:user_name] != current_user.login
  end

  def current_user
  	User.find_by(github_access_token: session[:github_access_token]) if session[:github_access_token]
  end

  def client
  	Octokit::Client.new(access_token: session[:github_access_token])
  end

  def signed_in?
    redirect_to root_path if !current_user
  end

end
