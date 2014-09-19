class User < ActiveRecord::Base

	has_many :websites

	def self.get_oauth_link
		return "https://github.com/login/oauth/authorize?client_id=#{ENV['GITHUB_CLIENT_ID']}"
	end

	def self.get_response(code_param)
		JSON.parse(RestClient.post("https://github.com/login/oauth/access_token", {client_id: ENV['GITHUB_CLIENT_ID'], client_secret: ENV['GITHUB_CLIENT_SECRET'], code: code_param}, { accept: :json }))
	end

	def self.new_client(access_token)
		Octokit::Client.new(:access_token => access_token).user
	end

	def self.show_login(github_access_token)
		user = User.find_by github_access_token: github_access_token
	end

	def self.search_users(term, github_access_token)
		if term != ""
			users = JSON.load(RestClient.get("https://api.github.com/legacy/user/search/" + term.gsub(' ','%20') + "?access_token=" + github_access_token))
		else
			"invalid_term"
		end
	end

end
