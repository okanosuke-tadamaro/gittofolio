class User < ActiveRecord::Base

	has_many :repositories
	has_many :websites

	def self.get_oauth_link
		return "https://github.com/login/oauth/authorize?client_id=#{ENV['GITHUB_CLIENT_ID']}"
	end

	def self.get_response(code_param)
		JSON.parse(RestClient.post("https://github.com/login/oauth/access_token", {client_id: ENV['GITHUB_CLIENT_ID'], client_secret: ENV['GITHUB_CLIENT_SECRET'], code: code_param}, { accept: :json }))
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

	def self.create_user(github_data)
		User.create(
      name: github_data.name,
      login: github_data.login,
      email: github_data.email,
      avatar: github_data.avatar_url,
      company: github_data.company,
      location: github_data.location,
      blog: github_data.blog
    )
	end

	def active_repositories
		self.repositories.where(display: true)
	end

	def inactive_repositories
		self.repositories.where(display: false)
	end

end
