class RepositoryController < ApplicationController

	def index

		@user = User.show_login(session[:github_access_token])

		if Repository.check_cache(params[:user_name]) == true
			@repositories = Repository.get_cached_repos(params[:user_name])
		else
			full_user_data = Repository.get_full_user_data(params[:user_name], session[:github_access_token])
			@repositories = Repository.get_repos(params[:user_name], session[:github_access_token])
			@repositories.each { |fetched_repository| Repository.create(name: fetched_repository[:name], description: fetched_repository[:description], language: fetched_repository[:language], owner: fetched_repository[:owner], avatar: fetched_repository[:avatar], full_name: full_user_data[:name], location: full_user_data[:location], company: full_user_data[:company], blog: full_user_data[:blog], homepage: fetched_repository[:homepage], start_date: fetched_repository[:start_date], update_date: fetched_repository[:update_date]) }
		end

		@full_name = Repository.get_basic_data(params[:user_name]).full_name
		@location = Repository.get_basic_data(params[:user_name]).location
		
		@pie_data = Repository.get_pie_data(@repositories)
		@languages = Repository.sort_repos(@repositories)
		@label = Repository.get_pie_label(@pie_data, @languages)

	end

	def by_language

		@repositories = Repository.get_repos(params[:user_name])
	
	end

	def detail
		if params[:format] != nil
			params[:repo_name] = "#{params[:repo_name]}.#{params[:format]}"
		end	
		
		@user = User.show_login(session[:github_access_token])

		@full_name = Repository.get_basic_data(params[:user_name])[:full_name]

		@homepage = Repository.get_homepage(params[:repo_name])

		@markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true)

		@data = if params[:repo_directory] == nil then
							Repository.get_repo_content(params[:user_name], params[:repo_name], session[:github_access_token])
						else
							Repository.get_repo_directory(params[:user_name], params[:repo_name], params[:repo_directory], session[:github_access_token])
						end

	end

end
