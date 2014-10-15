class ScreenshotsController < ApplicationController

	def create
		@screenshot = Screenshot.new(screenshot_params)
		if @screenshot.save
			redirect_to "/<%= current_user.login %>/settings"
		end
	end

	private

	def screenshot_params
		params.require(:screenshot).permit(:repository_id, :image)
	end

end
