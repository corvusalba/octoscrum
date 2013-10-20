module GitHubApiWrapper
	require 'octokit'

	module Base

		@id = nil
		@parent = nil
		@children = nil

		public
		def getChildren()
			return @children
		end

		def getId()
			return @id
		end

		def getParent()
			return @parent
		end
	end

	class RepoInfo
		attr_reader :org_name
		attr_reader :repo_name
		attr_reader :repo_id

		def initialize(org_name, repo_name, repo_id)
			@org_name = org_name
			@repo_name = repo_name
			@repo_id = repo_id
		end
	end

	class User
		include Base

		def initialize(token)
			@client = Octokit::Client.new :access_token => token

			@user = @client.user
			@id = @user.id
			@login = @user.login
			@children = getProjects			
		end

		public
		def getChildes()
			return @childes
		end

		def getId()
			return @id
		end

		def getLogin()
			return @login
		end

		def getOrgs()
			return @client.organizations
		end

		private 
		def getProjects()
			orgs = @client.organizations
		
			projectArray = [];

			orgs.each do |org|
				repos = @client.org_repos(org.login, {:type => 'member'})

				repos.each do |repo|
					repoInfo = RepoInfo.new(org.login, repo.name, repo.id)
					projectArray << Project.new(repoInfo, self)
				end
			end

			return projectArray
		end
	end

	class Project
		include Base

		def initialize(repoInfo, user)
			@repoInfo = repoInfo
			@parent = user			
			@children = getIterations()
		end

		public
		def getName()
			return @repoInfo.repo_name
		end

		def getId()
			return @repoInfo.repo_id
		end

		def getChildren()
			return @children
		end

		private
		def getIterations()
			milestones = []
			begin
			Octokit.list_milestones(@repoInfo.org_name + '/' + @repoInfo.repo_name, {:direction => 'desc'}).each do |milestone|
				milestones <<  Iteration.new(self, @repoInfo, milestone.number, milestone.title, milestone.description, milestone.due_on)
			end
			return milestones
			rescue Octokit::ClientError => e
				# puts e
			end
		end
	end

	class Iteration
		include Base

		def initialize(parent, repoInfo, number, title, description, due_on)
			@parent = parent
			@repoInfo = repoInfo
			@id = number
			@title = title
			@description = description
			@due_on = due_on

			@children = []
			@children.concat getUserStories
			@children.concat getBugs 

			@issues = getIssues			
		end
		
		public
		def getId()
			return @id
		end

		def getUserStoriesAndBugs()
			childesArray = []
			
			userStories = getUserStories()
			childesArray << userStories
			
			bugs = getBugs()
			childesArray << bugs

			return childesArray
		end

		private
		def getIssues()
			Octokit.list_issues(repoInfo.org_name + '/' + repoInfo.repo_name)	
		end

		def getUserStories()
			userStories = []

			@issues.each do |issue|
				issue.labels.each do |label|
					if !label.nil? && label.name == 'Type:UserStory'
						userStories <<  UserStory.new(self, repoInfo, issue.number, issue.title, issue.body)
					end
				end
			end
		end

		def getBugs()
			bugs = []

			@issues.each do |issue|
				issue.labels.each do |label|
					if !label.nil? && label.name == 'Type:Bug'
						userStories <<  Bug.new(self, repoInfo, issue.number, issue.title, issue.body)
					end
				end
			end
		end
	end

	class Bug
		include Base

		def initialize(parent, repoInfo, number, title, body)
			@parent = parent
			@id = number
			@repoInfo = repoInfo
			@title = title
			@body = body
		end

		def getTitle()
			return @title
		end

		def getBody()
			return @body
		end
	end
end
