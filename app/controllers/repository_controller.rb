class RepositoryController < ApplicationController

	def index
		
		@user = User.show_login(session[:github_access_token])

  		if Repository.check_cache(params[:user_name]) == true
  			@repositories = Repository.get_cached_repos(params[:user_name])
  		else
  			full_name_data = Repository.get_full_name_data(params[:user_name], session[:github_access_token])
  			@repositories = Repository.get_repos(params[:user_name], session[:github_access_token])
  			@repositories.each { |fetched_repository| Repository.create(name: fetched_repository[:name], description: fetched_repository[:description], language: fetched_repository[:language], owner: fetched_repository[:owner], avatar: fetched_repository[:avatar], full_name: full_name_data) }
  		end

  		full_name = Repository.get_full_name(params[:user_name]).full_name
  		@first_name = full_name.split(" ")[0]
		@last_name = full_name.split(" ")[1]

  		@pie_data = Repository.get_pie_data(@repositories)
		@languages = Repository.sort_repos(@repositories)
		@label = Repository.get_pie_label(@pie_data, @languages)

	end

	def by_language
		@repositories = Repository.get_repos(params[:user_name])
	end

	def detail
		@user = User.show_login(session[:github_access_token])

  		full_name = Repository.get_full_name(params[:user_name]).full_name
  		@first_name = full_name.split(" ")[0]
		@last_name = full_name.split(" ")[1]

		@data = Repository.get_repo_content(params[:user_name], params[:repo_name], session[:github_access_token])
	end

end
