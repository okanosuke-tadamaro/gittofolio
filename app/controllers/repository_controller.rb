class RepositoryController < ApplicationController

	before_action :signed_in?

	def index
		@repo_data = Repository.get_repo_data(client, params[:user_name])

		if Repository.check_cache(params[:user_name])
			@repositories = Repository.get_cached_repos(client, @repo_data, params[:user_name])
		else
			@repositories = Repository.get_repos(client, params[:user_name])
			@repositories.each { |fetched_repository| Repository.create(
				name: 				fetched_repository[:name],
				description: 	fetched_repository[:description],
				language: 		fetched_repository[:language],
				owner: 				fetched_repository[:owner],
				avatar: 			fetched_repository[:avatar],
				full_name: 		@repo_data[:name],
				location: 		@repo_data[:location],
				company: 			@repo_data[:company],
				blog: 				@repo_data[:blog],
				homepage: 		fetched_repository[:homepage],
				fork: 				fetched_repository[:fork],
				start_date: 	fetched_repository[:start_date].to_date,
				update_date: 	fetched_repository[:update_date].to_date
				) }
		end

			# USER INFO
			@full_name = @repositories.first[:full_name]
			@location = @repositories.first[:location]
			@github = "http://www.github.com/#{params[:user_name]}"

			@bar_data = Repository.get_barchart_data(@repositories)
			@pie_data = Repository.get_barchart_data(@repositories)
			@languages = Repository.get_languages(@repositories)
			@line_data = Repository.get_linechart_data(params[:user_name], session[:github_access_token])
			@line_chart = @line_data.first.zip(@line_data.last)
			colors = ["#1b5167", "#226682", "#297b9d", "#3091b8", "#3ea3cc", "#59b0d3", "#74bdda", "#8ec9e2", "#a9d6e9", "#c4e3f0", "#dff0f7"]
			@pie_colors = colors.take(@pie_data.size)
			@panel_label = @languages.zip(@pie_colors)
	end

	def detail
		require 'github/markup'

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
