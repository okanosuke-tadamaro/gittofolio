class Repository < ActiveRecord::Base
	def self.get_repos(username, github_access_token)
		client = Octokit::Client.new(access_token: github_access_token)
  		repositories = client.repositories(username)
  		parsed_repositories = repositories.inject(Array.new) { |array, repo| array << { name: repo[:name], description: repo[:description], language: repo[:language], owner: repo[:owner][:login], avatar: repo[:owner][:gravatar_id] } }
		parsed_repositories.each { |replace| if replace[:language] == nil then replace[:language] = "Other" end }
	end

	def self.get_full_name(username)
		client = Octokit::Client.new(access_token: github_access_token)
		user_attributes = client.user(username)
		user_attributes[:name]
	end

	def self.get_cached_repos(username)
		fetched_repo_data = Repository.where("owner = '#{username}'")
		fetched_repo_data.inject(Array.new) { |array, repo| array << { name: repo.name, description: repo.description, language: repo.language, owner: repo.owner, avatar: repo.avatar } }
	end

	def self.check_cache(username)
		if Repository.exists?(owner: username).class == Fixnum
			return true
		end
	end

	def self.sort_repos(repositories)
		language_list = repositories.map { |language| language[:language] }
		counts = language_list.inject(Hash.new(0)) {|hash,language| hash[language] += 1; hash}
		ordered_counts = Hash[counts.sort_by {|k,v| v}.reverse]
		language_unordered = ordered_counts.keys
		language_delete = language_unordered.delete("Other")
		languages = language_unordered.push("Other")
	end

	def self.get_pie_data(values)
		value_list = values.map { |value| value[:language] }
		counts = value_list.inject(Hash.new(0)) {|hash,language| hash[language] += 1; hash}
		ordered_counts = Hash[counts.sort_by {|k,v| v}.reverse]
		color_data = ['#1abc9c','#f1c40f','#3498db','#e74c3c','#2c3e50','#bdc3c7','#e67e22','#2ecc71','#ecf0f1','#8e44ad']
		pie_data = ordered_counts.values.map {|data| "{" + "value: #{data}, color: '#{color_data.delete_at(rand(color_data.length))}'" + "}"}
	end
end