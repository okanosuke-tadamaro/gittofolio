class User < ActiveRecord::Base
	def self.show_login(github_access_token)
		user = User.find_by github_access_token: github_access_token
	end

	def self.search_users(term, github_access_token)
		if term != ""
			users = JSON.load(RestClient.get("https://api.github.com/legacy/user/search/" + term.gsub(' ','%20') + "?access_token=" + github_access_token))
		else
			"No"
		end
	end
end
