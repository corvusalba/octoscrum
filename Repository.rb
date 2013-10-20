module Repository
    require 'octokit'
    require './poco.rb'

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

    class UserRepository
        def getGravatarId(login, token)
            @client = Octokit::Client.new(:login => login, :oauth_token => token, :access_token => token)
            return @client.user.gravatar_id
        end
    end

    class ProjectRepository

        def initialize(login, token)
            @login = login
            @token = token
            @client = Octokit::Client.new(:login => login, :oauth_token => token, :access_token => token)
            @parent = client.user
            @children = getChildren()
            @type = 'project'
        end

        public
        def getProjects(login, token)
            client = Octokit::Client.new(:login => login, :oauth_token => token, :access_token => token)
            repos = @client.repos(login)
            projects = []
            @client.repos().each do |repo|
                projects << Project.new(repo.name, repo.title, login)
            end
            return projects
        end

        def getFull()

        end

        private
        def getChildren()
            milestones = []
            
            orgs = @client.organizations

            orgs.each do |org|
                milestones.concat getOrgIterations(org)
                milestones.concat getUserIterations
            end

            return milestones
        end

        def getOrgIterations(org)
            milestones = []

            repos = Octokit.org_repos(org.login, {:type => 'member'})

            repos.each do |repo|
                begin
                    Octokit.list_milestones(org.login + '/' + repo.name, {:direction => 'desc'}).each do |milestone|
                        milestones <<  milestone.number
                    end
                    return milestones
                    rescue Octokit::ClientError => e
                    # Не забыть выбросить Exception!!!!!!!!!!!!!!!!!!!!!!!!!!
                end
            end
        end

        def getUserIterations()
            projects = []
            @client.repos().each do |repo|
                 begin
                    Octokit.list_milestones(@parent.login + '/' + repo.name, {:direction => 'desc'}).each do |milestone|
                        milestones <<  milestone.number
                    end
                    return milestones
                    rescue Octokit::ClientError => e
                    # Не забыть выбросить Exception!!!!!!!!!!!!!!!!!!!!!!!!!!
                end
            end
            return projects
        end

        def getOrgProjects()
            orgs = @client.organizations
        
            projectArray = [];

            orgs.each do |org|
                repos = @client.org_repos(org.login, {:type => 'member'})

                repos.each do |repo|
                    projectArray << Project.new(repo.id, repo.title, @parent, org.login)
                end
            end

            return projectArray
        end

        def getUserProjects(withChildren)
            projects = []
            @client.repos().each do |repo|
                projects << Project.new(repo.id, repo.title, @parent, -1)
            end

            return projects
        end        
    end

    class IterationRepository

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
        def getIteration()
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

    class IssueRepository

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