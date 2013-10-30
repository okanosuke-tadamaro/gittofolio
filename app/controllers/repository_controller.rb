class RepositoryController < ApplicationController

	def index
		@repositories = Repository.get_repos(params[:user_name])

		# Save the user repo info to Repository model (cache it)
  		@repositories.each do |fetched_repository|
  			repository.create(name: fetched_repository[:name], description: fetched_repository[:description], owner: fetched_repository[:owner])
  		end
  		
		@languages = Repository.sort_repos(@repositories)
	end

	def by_language
		@repositories = Repository.get_repos(params[:user_name])
	end

end
