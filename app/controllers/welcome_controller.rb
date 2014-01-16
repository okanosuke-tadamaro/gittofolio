class WelcomeController < ApplicationController
  def index
    @current_user = User.find_by github_access_token: session[:github_access_token]
  end

  def user_search
    @current_user = User.find_by github_access_token: session[:github_access_token]
    @users = User.search_users(params[:q], session[:github_access_token])
    if @users == "invalid_term"
      flash[:alert] = "Invalid search term. Please try again."
      redirect_to root_path
    elsif @users.fetch("users").empty? == true
      flash[:notice] = "The user you searched for doesn't seem to exist. Try searching again using a different term."
      redirect_to root_path  
    else
      @users["users"].each { |replace| if replace["fullname"] == " " or replace["fullname"] == nil then replace["fullname"] = "Name Not Available" end }
      @users["users"].each { |replace| if replace["location"] == nil or replace["location"] == "" then replace["location"] = "Location Not Available" end }
    end
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

    flash[:notice] = "You're signed in!"
  	redirect_to root_url #"/#{user.login}"
  end

  def signout
    session[:github_access_token] = nil
    flash[:notice] = "You've successfully signed out. Thanks for using Gittofolio!"
    redirect_to root_path
  end
end