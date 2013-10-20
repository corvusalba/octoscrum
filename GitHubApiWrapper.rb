module GitHubApiWrapper
    require 'octokit'

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

        def initialize(token)
            @client = Octokit::Client.new :access_token => token

            @user = @client.user
            @id = @user.id
            @login = @user.login
            @projects = getProjects()
            @orgProjects = getOrgProjects()
            @children = getChildren()
            @type = 'user'
        end

        private 
        def getOrgProjects()
            orgs = @client.organizations
        
            projectArray = [];

            orgs.each do |org|
                repos = @client.org_repos(org.login, {:type => 'member'})

                repos.each do |repo|
                    repoInfo = RepoInfo.new(org.login, repo.name, repo.id)
                    projectArray << Project.new(repoInfo, @id)
                end
            end

            return projectArray
        end

        def getProjects()
            projects = []
            @client.repos().each do |repo|
                repoInfo = RepoInfo.new(@user.login, repo.name, repo.id)
                projects << Project.new(repoInfo, @id)
            end
            return projects
        end

        def getChildren()
            children = []
            @projects.each do |project|
                children << project.getId()
            end
            @orgProjects.each do |project|
                children << project.getId()
            end
            return children
        end
    end

    class Project

        def initialize(repoInfo, user)
            @repoInfo = repoInfo
            @parent = user          
            @children = getIterations()
            @type = 'project'
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

        def initialize(parent, repoInfo, number, title, description, due_on)
            @parent = parent
            @repoInfo = repoInfo
            @id = number
            @title = title
            @description = description
            @due_on = due_on

            @issues = getIssues
            @type = 'iteration'
        end
        
        public
        def getId()
            return @id
        end

        private
        def getIssues()
            issues = []
            Octokit.list_issues(repoInfo.org_name + '/' + repoInfo.repo_name).each do |issue|
                issue << Issue.new(@id, repoInfo.repo_name, issue.number, issue.title, issue.body, issue.labels)
            end
            return issues
        end
    end

    class Issue

        def initialize(parent, repoInfo, number, title, body, labels)
            @parent = parent
            @id = number
            @repoInfo = repoInfo
            @title = title
            @body = body
            @type = nil
            @priority = nil
            @status = nil

            labels.each do |label|
                if !label.nil?
                    if label.name.include? 'Type'
                        @type = label.name[5..-1]
                    end
                    if label.name.include? 'Priority'
                        @priority = label.name[9..-1]
                    end
                    if label.name.include? 'Status'
                        @status = label.name[7..-1]
                    end
                end
            end
        end
    end
end
