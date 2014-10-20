class ScreenshotsController < ApplicationController

	def create
		@screenshot = Screenshot.new(screenshot_params)
		@repository = @screenshot.repository_id
		if @screenshot.save
			redirect_to "/#{current_user.login}/#{@repository.repo_id}"
		end
	end

	def update
		
	end

	def destroy
		
	end

	private

	def screenshot_params
		params.require(:screenshot).permit(:repository_id, :image)
	end

end
