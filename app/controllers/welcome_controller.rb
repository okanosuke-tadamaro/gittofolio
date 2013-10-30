class WelcomeController < ApplicationController
  def index
  	# Thanks for logging in?
  end

  def callback
  	response = RestClient.post("https://github.com/login/oauth/access_token", {client_id: GITHUB_CLIENT_ID, client_secret: GITHUB_CLIENT_SECRET, code: params["code"]}, { accept: :json })
  	parsed_response = JSON.parse(response)
  	# current_user is a method in devise / github_access_token to be a field in the user model
  	current_user.github_access_token = parsed_response["access_token"]
  	redirect_to root_path
  end
end
