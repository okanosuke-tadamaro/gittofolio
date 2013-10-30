class Repository < ActiveRecord::Base
	def self.get_repos(username)
		client = Octokit::Client.new access_token: current_user.github_access_token
  		user = Octokit.user(username)
  		repositories = user.rels[:repos].get.data
  		parsed_repositories = repositories.inject(Array.new) { |array, repo| array << { name: repo[:name], description: repo[:description], language: repo[:language], owner: repo[:owner][:login], avatar: repo[:owner][:gravatar_id] } }
	end

	def self.sort_repos(repositories)
		@language_list = repositories.map { |language| language[:language] }
		@counts = @language_list.inject(Hash.new(0)) {|hash,language| hash[language] += 1; hash}
		@language_unordered = @counts.keys
		@Language_delete = @language_unordered.delete("Other")
		@languages = @language_unordered.push("Other")
	end
end