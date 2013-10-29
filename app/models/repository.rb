class Repository < ActiveRecord::Base
	def self.get_repos(username)
		user_name = username
		response = JSON.load(RestClient.get("https://api.github.com/users/#{user_name}/repos"))
		response.each { |repo| if repo["language"] == nil then repo["language"] = "Other" end }
		repositories = response.inject(Array.new) { |repositories, response| repositories << { name: response['name'], language: response['language'], description: response['description'], avatar: "#{response['owner']['avatar_url']}&s=300" } }
		repositories
	end

	def self.sort_repos(repositories)
		@language_list = repositories.map { |language| language[:language] }
		@counts = @language_list.inject(Hash.new(0)) {|hash,language| hash[language] += 1; hash}
		@language_unordered = @counts.keys
		@Language_delete = @language_unordered.delete("Other")
		@languages = @language_unordered.push("Other")
	end
end