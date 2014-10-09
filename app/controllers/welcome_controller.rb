class WelcomeController < ApplicationController
  
  def welcome
    @oauth_link = User.get_oauth_link
  end

  def index ; end

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
    session[:github_access_token] = response["access_token"]
    client_info = client.user

    if !User.exists?(login: client_info.login)
      User.create(
        name: client_info.name,
        login: client_info.login,
        email: client_info.email,
        avatar: client_info.avatar_url,
        company: client_info.company,
        location: client_info.location,
        blog: client_info.blog,
        github_access_token: response["access_token"]
      )
    elsif User.exists?(login: client_info.login) && User.find_by(login: client_info.login).github_access_token.nil?
      user = User.find_by(login: client_info.login)
      user.update(github_access_token: session[:github_access_token])
    end

    flash[:notice] = "You're signed in!"
  	redirect_to "/#{client.login}/settings"
  end

  def signout
    session[:github_access_token] = nil
    flash[:notice] = "You've successfully signed out. Thanks for using Gittofolio!"
    redirect_to root_path
  end

end
