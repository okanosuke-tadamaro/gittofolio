class RepositoryController < ApplicationController

	def index
		@current_user = User.find_by github_access_token: session[:github_access_token]
		client = Repository.new_request(session[:github_access_token])
		@full_user_data = Repository.get_full_user_data(client, params[:user_name], session[:github_access_token])

		if User.search_users(params[:user_name], session[:github_access_token]).fetch("users").empty? == true
			flash[:alert] = "The user you searched for doesn't seem to exist. You might want to try searching by name."
			redirect_to root_path
		else
			if params[:user_name] != "javascripts"

			if Repository.check_cache(params[:user_name]) == true
				@repositories = Repository.get_cached_repos(client, @full_user_data, params[:user_name])
			else
				@repositories = Repository.get_repos(client, params[:user_name])
				@repositories.each { |fetched_repository| Repository.create(
					name: fetched_repository[:name],
					description: fetched_repository[:description],
					language: fetched_repository[:language],
					owner: fetched_repository[:owner],
					avatar: fetched_repository[:avatar],
					full_name: @full_user_data[:name],
					location: @full_user_data[:location],
					company: @full_user_data[:company],
					blog: @full_user_data[:blog],
					homepage: fetched_repository[:homepage],
					fork: fetched_repository[:fork],
					start_date: fetched_repository[:start_date].to_date,
					update_date: fetched_repository[:update_date].to_date
					) }
			end

			@full_name = Repository.get_basic_data(params[:user_name]).full_name
			@location = Repository.get_basic_data(params[:user_name]).location
			@pie_data = Repository.get_pie_data(@repositories)
			@languages = Repository.sort_repos(@repositories)
			@line_chart = Repository.get_event_data(params[:user_name], session[:github_access_token])
			colors = ["#1b5167", "#226682", "#297b9d", "#3091b8", "#3ea3cc", "#59b0d3", "#74bdda", "#8ec9e2", "#a9d6e9", "#c4e3f0", "#dff0f7"]
			@pie_colors = colors.take(@pie_data.size)
			@panel_label = @languages.zip(@pie_colors)

			end
		end
	end

	def detail
		require 'github/markup'

		@current_user = User.find_by github_access_token: session[:github_access_token]

		if params[:format] != nil
			params[:repo_name] = "#{params[:repo_name]}.#{params[:format]}"
		end	
		
		@user = User.show_login(session[:github_access_token])
		@full_name = Repository.get_basic_data(params[:user_name])[:full_name]
		@homepage = Repository.get_homepage(params[:repo_name])


		if params[:repo_directory] != nil
			@breadcrumb = params[:repo_directory].split('/')
		else
			@breadcrumb = []
		end

		@markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true)

		@data = if params[:repo_directory] == nil then
					Repository.get_repo_content(params[:user_name], params[:repo_name], session[:github_access_token])
				else
					Repository.get_repo_directory(params[:user_name], params[:repo_name], params[:repo_directory], session[:github_access_token])
				end

		@data.each do |readme|
			if readme[:name].downcase.include?("readme")
				@readme_name = readme[:name]
				@readme_content = Base64.decode64(readme.rels[:self].get.data[:content])
			end
		end
	end

end
