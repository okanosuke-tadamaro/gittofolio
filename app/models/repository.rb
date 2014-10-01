class Repository < ActiveRecord::Base

	def self.check_cache(username)
		true if Repository.exists?(owner: username)
	end

	def self.get_repo_data(client, username)
		client.user(username)
	end

	def self.get_repos(client, username)
		#
		# MAKE NEW REQUEST TO GITHUB TO GET REPOSITORY INFO FOR A CERTAIN USER
		#
  	repositories = client.repositories(username)
  	parsed_repositories = repositories.inject(Array.new) { |array, repo| array << {
			name: 				repo[:name],
			description: 	repo[:description],
			language: 		repo[:language],
			owner: 				repo[:owner][:login],
			avatar: 			repo[:owner][:gravatar_id],
			homepage: 		repo[:homepage],
			fork: 				repo[:fork],
			start_date: 	repo[:created_at],
			update_date: 	repo[:updated_at]
			} }
		parsed_repositories.each { |replace| if replace[:language] == nil then replace[:language] = "Other" end }
		parsed_repositories.each { |thumb| if thumb[:homepage] == nil || thumb[:homepage] == "" then thumb[:homepage] = "not_available" end }
		parsed_repositories.each { |to_string| if to_string[:description] == nil then to_string[:description] = "" end }
		parsed_repositories.sort_by { |date| date[:update_date] }.reverse
	end

	def self.get_cached_repos(client, user_data, username)
		#
		# UPDATE USER REPOSITORY
		#
		if user_data[:updated_at].to_date > Repository.where(:owner => username).sort_by { |date| date.update_date }.reverse.first.update_date
			repositories = Repository.get_repos(client, username)
			
			#
			# CHECK FOR DELETED REPOS
			#
			Repository.where(:owner => username).each do |repo|
				Repository.destroy(repo.id) if repositories.any? { |check| check[:name] == repo.name } == false
			end

			repositories.each do |repo|
				#
				# CHECK FOR NEW REPOSITORIES
				#
				if Repository.where(:owner => username, :name => repo[:name]).exists? == nil
					Repository.create(
						name: 				repo[:name],
						description: 	repo[:description],
						language: 		repo[:language],
						owner: 				repo[:owner],
						avatar: 			repo[:avatar],
						full_name: 		user_data[:name],
						location: 		user_data[:location],
						company: 			user_data[:company],
						blog: 				user_data[:blog],
						homepage: 		repo[:homepage],
						fork: 				repo[:fork],
						start_date: 	repo[:start_date].to_date,
						update_date: 	repo[:update_date].to_date
					)
				else
					repository = Repository.find_by(:owner => username, :name => repo[:name])
					Repository.update( repository.id, {
						name: 				repo[:name],
						description: 	repo[:description],
						language: 		repo[:language],
						owner: 				repo[:owner],
						avatar: 			repo[:avatar],
						full_name: 		user_data[:name],
						location: 		user_data[:location],
						company: 			user_data[:company],
						blog: 				user_data[:blog],
						homepage: 		repo[:homepage],
						fork: 				repo[:fork],
						start_date: 	repo[:start_date].to_date,
						update_date: 	repo[:update_date].to_date
						}
					)
				end
			end
		end
		fetched_repo_data = Repository.where(:owner => username)
		inject_repo_data = fetched_repo_data.inject(Array.new) { |array, repo| array << {
			name: 				repo.name,
			description: 	repo.description,
			language: 		repo.language,
			owner: 				repo.owner,
			avatar: 			repo.avatar,
			full_name: 		repo.full_name,
			location: 		repo.location,
			company: 			repo.company,
			blog: 				repo.blog,
			homepage: 		repo.homepage,
			fork: 				repo.fork,
			start_date: 	repo.start_date,
			update_date: 	repo.update_date
			} }
		inject_repo_data.sort_by { |date| date[:update_date] }.reverse
	end

	def self.get_languages(repositories)
		language_list = repositories.map { |language| language[:language] }
		counts = language_list.inject(Hash.new(0)) {|hash,language| hash[language] += 1; hash}
		ordered_counts = Hash[counts.sort_by {|k,v| v}.reverse]
		language_unordered = ordered_counts.keys
		language_delete = language_unordered.delete("Other")
		languages = language_unordered.push("Other")
	end

	# GET A REPOSITORY'S LANGUAGE LIST
	def get_repo_language(username, repo, github_access_token)
		
	end

	# GET USER'S ACTIVITY FOR THE PAST 2 WEEKS
	def self.get_linechart_data(username, github_access_token)
		dates = (2.weeks.ago.to_date .. Date.yesterday).map { |date| date.to_s }
		event_data = JSON.load(RestClient.get('https://api.github.com/users/' + username + '/events?per_page=50&access_token=' + github_access_token)).map { |repo| repo['created_at'].to_date.to_s }
		return_data = dates.inject([]) { |arr, date| arr << event_data.count { |repo_date| repo_date == date } }
		return [dates.map { |date| date[5..9].gsub('-','/') }, return_data]
	end

	def self.get_barchart_data(values)
		value_list = values.map { |value| value[:language] }
		counts = value_list.inject(Hash.new(0)) {|hash,language| hash[language] += 1; hash}
		ordered_counts = Hash[counts.sort_by {|k,v| v}.reverse]
		if ordered_counts.size > 3
			return [ordered_counts.keys[0..2], ordered_counts.values[0..2]]
		else
			return [ordered_counts.keys, ordered_counts.values]
		end
	end

	def self.get_single_repository(client, username, repo_name)
		languages = client.languages(username + '/' + repo_name) #=> Hash
		commits = client.commits(username + '/' + repo_name)
		return {
			radar_data: {language_labels: languages.to_hash.keys.map { |key| key.to_s }, language_values: languages.to_hash.values}
		}
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