class ApiController < ApplicationController

	respond_to :json
	before_filter :define_access_control_headers

	def activity
		if User.exists?(login: params[:user])
			user = User.find_by(login: params[:user])
			if user.websites.exists?(url: request.env['REMOTE_HOST']) || true
				repositories = Repository.where(owner: params[:user])
				return_data = Repository.get_linechart_data(user.login, user.github_access_token)
			end
		end
		render json: {status: true, data: return_data}.to_json
	end

	private

	  def define_access_control_headers
	    headers['Access-Control-Allow-Origin'] = '*'
	    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
	    headers['Access-Control-Max-Age'] = "1728000"
	  end

end
