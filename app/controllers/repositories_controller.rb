class RepositoriesController < ApplicationController

	before_action :signed_in?

	def index
		@user_data = Repository.get_user_info(client, params[:user_name])
		@user = !User.exists?(login: params[:user_name]) ? User.create_user(@user_data) : User.find_by(login: params[:user_name])

    # UPDATE REPOSITORIES
		repositories = Repository.get_repos(client, @user.login)
		if @user.repositories.any?
			repositories = Repository.get_cached_repos(client, @user_data, @user, repositories)
		else
			repositories.each do |repo|
				@user.repositories.create(
					repo_id: repo[:repo_id].to_i,
					name: repo[:name],
					description: repo[:description],
					language: repo[:language],
					homepage: repo[:homepage],
					fork: repo[:fork],
					start_date: repo[:start_date].to_date,
					update_date: repo[:update_date].to_date
				)
			end
		end

		# REPOSITORY LIST
		@imaged_repositories = repositories.select { |repository| repository[:homepage] != "not_available" }
		@forked_repositories = repositories.select { |repository| repository[:fork] }
		@regular_repositories = repositories.select { |repository| !repository[:fork] && repository[:homepage] == "not_available" }

		# USER INFO
		@full_name = @user.name
		@location = @user.location
		@github = "http://www.github.com/#{params[:user_name]}"

		@bar_data = Repository.get_barchart_data(repositories)
		@pie_data = Repository.get_barchart_data(repositories)
		@languages = Repository.get_languages(repositories)
		@line_data = Repository.get_linechart_data(params[:user_name], current_user.github_access_token)
		@line_chart = @line_data.first.zip(@line_data.last)
		colors = ["#1b5167", "#226682", "#297b9d", "#3091b8", "#3ea3cc", "#59b0d3", "#74bdda", "#8ec9e2", "#a9d6e9", "#c4e3f0", "#dff0f7"]
		@pie_colors = colors.take(@pie_data.size)
		@panel_label = @languages.zip(@pie_colors)
	end

	def show
		@repository = Repository.find_by(repo_id: params[:repo_id])
		@screenshot = @repository.screenshots.new
		@user = @repository.user
	end

	def update
		@repository = Repository.find_by(repo_id: params[:repo_id])
		@repository.update(repo_params)
		redirect_to "/#{current_user.login}/#{@repository.repo_id}"
	end

	def update_display
		respond_to do |format|
			format.html {}
			format.json {
				repository = Repository.find(params[:repo_id])
				if repository.user.login == current_user.login
					repository.display = params[:display]
					if repository.save
						render json: { status: true, repo: repository }.to_json
					else
						render json: { status: false, repo: repository }.to_json
					end
				else
					render json: { status: false, repo: repository }.to_json
				end
			}
		end
	end

	private

	def repo_params
		params.require(:repository).permit(:description)
	end

end