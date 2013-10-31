class RepositoryController < ApplicationController

	def index
		@repositories = Repository.get_repos(params[:user_name])

		# Save the user repo info to Repository model (cache it)
  		@repositories.each do |fetched_repository|
  			Repository.create(name: fetched_repository[:name], description: fetched_repository[:description], language: fetched_repository[:language], owner: fetched_repository[:owner], avatar: fetched_repository[:avatar])
  		end
  		
		@languages = Repository.sort_repos(@repositories)
	end

	def by_language
		@repositories = Repository.get_repos(params[:user_name])
	end

end
