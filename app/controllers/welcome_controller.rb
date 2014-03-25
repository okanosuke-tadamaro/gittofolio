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
  	response = User.get_response(params["code"])
    client = User.new_client(response["access_token"])
    session[:github_access_token] = response["access_token"]

    if User.exists?(login: client.login) == nil
      User.create(
        name: client.name,
        login: client.login,
        location: client.location,
        email: client.email,
        github_access_token: response["access_token"]
        )
    end

    flash[:notice] = "You're signed in!"
  	redirect_to "/#{client.login}"
  end

  def signout
    session[:github_access_token] = nil
    flash[:notice] = "You've successfully signed out. Thanks for using Gittofolio!"
    redirect_to root_path
  end
end
