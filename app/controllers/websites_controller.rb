class WebsitesController < ApplicationController

	def create
		@website = current_user.websites.new(website_params)
		if @website.save
			redirect_to("/#{current_user.name}/settings")
		else
			redirect_to("/#{current_user.name}/settings")
		end
	end

	private

		def website_params
			params.require(:website).permit(:url)
		end

end
