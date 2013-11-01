class RepositoryController < ApplicationController

	def index
		# @repositories = Repository.get_repos(params[:user_name], session[:github_access_token])

  # 		@repositories.each do |fetched_repository|
  # 			Repository.create(name: fetched_repository[:name], description: fetched_repository[:description], language: fetched_repository[:language], owner: fetched_repository[:owner], avatar: fetched_repository[:avatar])
  # 		end

  		if Repository.check_cache(params[:user_name]) == true
  			@repositories = Repository.get_cached_repos(params[:user_name])
  			binding.pry
  		else
  			@repositories = Repository.get_repos(params[:user_name], session[:github_access_token])
  			@repositories.each { |fetched_repository| Repository.create(name: fetched_repository[:name], description: fetched_repository[:description], language: fetched_repository[:language], owner: fetched_repository[:owner], avatar: fetched_repository[:avatar]) }
  		end

  		@pie_data = Repository.get_pie_data(@repositories)
		@languages = Repository.sort_repos(@repositories)
	end

	def by_language
		@repositories = Repository.get_repos(params[:user_name])
	end

end
