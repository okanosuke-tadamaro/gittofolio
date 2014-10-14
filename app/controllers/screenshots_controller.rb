class ScreenshotsController < ApplicationController

	def create
		
	end

	private

	def screenshot_params
		params.require(:screenshot).permit(:original_url)
	end

end
