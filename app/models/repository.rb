class Repository < ActiveRecord::Base
	def self.get_repos(username)
		client = Octokit::Client.new access_token: @github_access_token
  		user = Octokit.user(username)
  		repositories = user.rels[:repos].get.data
  		parsed_repositories = repositories.inject(Array.new) { |array, repo| array << { name: repo[:name], description: repo[:description], language: repo[:language], owner: repo[:owner][:login], avatar: repo[:owner][:gravatar_id] } }
		parsed_repositories.each { |replace| if replace[:language] == nil then replace[:language] = "Other" end }
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
	end
end