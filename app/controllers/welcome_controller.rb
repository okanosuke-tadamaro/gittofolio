class WelcomeController < ApplicationController
  def index
  	
  end

  def callback
    response = RestClient.post("https://github.com/login/oauth/access_token", {client_id: ENV['GITHUB_CLIENT_ID'], client_secret: ENV['GITHUB_CLIENT_SECRET'], code: params["code"]}, { accept: :json })
  	parsed_response = JSON.parse(response)
    client = Octokit::Client.new :access_token => parsed_response["access_token"]
    user = client.user
    user.login

    if User.exists?(login: user.login) == nil
      User.create(name: user.name, login: user.login, location: user.location, email: user.email, github_access_token: parsed_response["access_token"])
    end

    session[:github_access_token] = parsed_response["access_token"]

  	redirect_to root_path
  end
end