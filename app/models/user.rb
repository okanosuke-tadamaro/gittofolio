class User < ActiveRecord::Base
	def self.show_login(github_access_token)
		user = User.find_by github_access_token: github_access_token
	end
end
