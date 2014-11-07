class WebsitesController < ApplicationController

	def create
		@website = current_user.websites.new(website_params)
		if @website.save
			redirect_to "/#{current_user.login}"
		else
			redirect_to "/#{current_user.login}"
		end
	end

	private

		def website_params
			params.require(:website).permit(:url)
		end

end
