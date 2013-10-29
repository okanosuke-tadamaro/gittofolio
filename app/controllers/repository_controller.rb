class RepositoryController < ApplicationController

	def index
		@repositories = Repository.get_repos(params[:user_name])
		@languages = Repository.sort_repos(@repositories)
	end

	def by_language
		@repositories = Repository.get_repos(params[:user_name])
	end

end
