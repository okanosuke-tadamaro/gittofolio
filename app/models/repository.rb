class Repository < ActiveRecord::Base
	
	def self.check_cache(username)
		if Repository.exists?(owner: username).class == Fixnum
			return true
		end
	end

	def self.new_request(github_access_token)
		Octokit::Client.new(access_token: github_access_token)
	end

	def self.get_repos(client, username)
  		repositories = client.repositories(username)
  		parsed_repositories = repositories.inject(Array.new) { |array, repo| array << { name: repo[:name], description: repo[:description], language: repo[:language], owner: repo[:owner][:login], avatar: repo[:owner][:gravatar_id], homepage: repo[:homepage], start_date: repo[:created_at], update_date: repo[:updated_at] } }
		parsed_repositories.each { |replace| if replace[:language] == nil then replace[:language] = "Other" end }
		parsed_repositories.each { |thumb| if thumb[:homepage] == nil || thumb[:homepage] == "" then thumb[:homepage] = "not_available" end }
		parsed_repositories.sort_by { |date| date[:update_date] }.reverse
	end

	def self.get_full_user_data(client, username, github_access_token)
		client.user(username)
	end

	def self.get_basic_data(username)
		Repository.find_by owner: username
	end

	def self.get_cached_repos(client, user_data, username)
		if user_data[:updated_at].to_date > Repository.where(:owner => username).sort_by { |date| date.update_date }.reverse.first.update_date
			repositories = Repository.get_repos(client, username)
			Repository.where(:owner => username).each do |repo|
				if repositories.any? {|check| check[:name] == repo.name } == false then Repository.destroy(repo.id) end
			end
			repositories.each do |repo|
				if Repository.where(:owner => username, :name => repo[:name]).exists? == nil
					Repository.create(
						name: repo[:name],
						description: repo[:description],
						language: repo[:language],
						owner: repo[:owner],
						avatar: repo[:avatar],
						full_name: user_data[:name],
						location: user_data[:location],
						company: user_data[:company],
						blog: user_data[:blog],
						homepage: repo[:homepage],
						start_date: repo[:start_date].to_date,
						update_date: repo[:update_date].to_date
					)															
				else
					repository = Repository.find_by(:owner => username, :name => repo[:name])
					Repository.update( repository.id, {
						name: repo[:name],
						description: repo[:description],
						language: repo[:language],
						owner: repo[:owner],
						avatar: repo[:avatar],
						full_name: user_data[:name],
						location: user_data[:location],
						company: user_data[:company],
						blog: user_data[:blog],
						homepage: repo[:homepage],
						start_date: repo[:start_date].to_date,
						update_date: repo[:update_date].to_date
						}
					)
				end
			end
		end
		fetched_repo_data = Repository.where(:owner => username)
		inject_repo_data = fetched_repo_data.inject(Array.new) { |array, repo| array << { name: repo.name, description: repo.description, language: repo.language, owner: repo.owner, avatar: repo.avatar, full_name: repo.full_name, location: repo.location, company: repo.company, blog: repo.blog, homepage: repo.homepage, start_date: repo.start_date, update_date: repo.update_date } }
		inject_repo_data.sort_by { |date| date[:update_date] }.reverse
	end

	def self.sort_repos(repositories)
		language_list = repositories.map { |language| language[:language] }
		counts = language_list.inject(Hash.new(0)) {|hash,language| hash[language] += 1; hash}
		ordered_counts = Hash[counts.sort_by {|k,v| v}.reverse]
		language_unordered = ordered_counts.keys
		language_delete = language_unordered.delete("Other")
		languages = language_unordered.push("Other")
	end

	def self.get_event_data(username, github_access_token)
		event_data = JSON.load(RestClient.get("https://github.com/users/" + username + "/contributions_calendar_data?access_token=" + "#{github_access_token}"))
		filter_line_chart_data = event_data.select {|x| x[0].to_date >= Date.today - 55.days}
		dates = filter_line_chart_data.map {|date| date.first.to_date}.in_groups_of(7,false).map {|date| date.last}
		graph_data = filter_line_chart_data.map {|graph| graph.last}.in_groups_of(7,false).map {|graph| graph.sum}
		all_data = dates.zip(graph_data)
	end

	def self.get_pie_data(values)
		value_list = values.map { |value| value[:language] }
		counts = value_list.inject(Hash.new(0)) {|hash,language| hash[language] += 1; hash}
		ordered_counts = Hash[counts.sort_by {|k,v| v}.reverse]
		# color_data = ['#1abc9c','#f1c40f','#3498db','#e74c3c','#2c3e50','#bdc3c7','#e67e22','#2ecc71','#ecf0f1','#8e44ad']
		# pie_data = ordered_counts.values.map {|data| "{" + "value: #{data}, color: '#{color_data.delete_at(rand(color_data.length))}'" + "}"}
	end

	def self.get_pie_label(data,language)
		colors = data.map { |color| color.scan(/(?<=#)(?<!^)(\h{6}|\h{3})/).first.first }
		bundled_data = language.zip(colors)
	end

	def self.get_homepage(repo_name)
		homepage = Repository.find_by name: repo_name
	end

	def self.get_repo_content(username, repo, github_access_token)
		client = Octokit::Client.new(access_token: github_access_token)
		data = client.contents("#{username}/#{repo}")
	end

	def self.get_repo_directory(username, repo, directory, github_access_token)
		client = Octokit::Client.new(access_token: github_access_token)
		data = client.contents("#{username}/#{repo}", :path => directory)
	end

end