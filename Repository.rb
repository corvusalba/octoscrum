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
        def getProjects(login, token)
            client = Octokit::Client.new(:login => login, :oauth_token => token, :access_token => token)
            projects = []
            client.repos().each do |repo|
                projects << Project.new(repo.name, repo.title, login)
            end
            client.org_repos(org.login, {:type => 'member'}).each do |repo|
                projects << Project.new(repo.name, repo.title, login)
            end
            return projects
        end

        def getFull(login, token, repoName)
            client = Octokit::Client.new(:login => login, :oauth_token => token, :access_token => token)
            children = []
            client.list_milestones(login + '/' + repoName, {:direction => 'desc'}).each do |iter|
                issues = []
                client.list_issues(login + '/' + repoName).each do |issue|
                    if issue.milestone == iter.number
                        issues << issue.number
                    end
                end
                children << Iteration.new(iter.number, iter.title, repoName, issues)
            end

            client.list_issues(login + '/' + repoName).each do |issue|
                if !issue.milestone?
                    issue.labels.each do |label|
                        if !label.nil?
                            if label.name.include? 'Type'
                                type = label.name[5..-1].downcase
                            end
                            if label.name.include? 'Priority'
                                priority = label.name[9..-1].downcase
                            end
                            if label.name.include? 'Status'
                                status = label.name[7..-1].downcase
                            end
                        end
                    end
                    children << Issue.new(issue.number, issue.title, issue.body, type, priority, status, -1, -1)
                end
            end

            return children
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

        def addIteration(iteration, ownerName, repoName)
            Octokit.create_milestone(ownerName + '/' + repoName, iteration.title, {:description => iteration.description, :due_on => iteration.due_on})
        end

        def updateIteration(iteration, ownerName, repoName)
            Octokit.update_milestone(ownerName + '/' + repoName, iteration.id, {:title => iteration.due_on, :description => iteration.description, :due_on => iteration.due_on})
        end

        def deleteIteration(ownerName, repoName, iteration)
            Octokit.delete_milestone(ownerName + '/' + repoName, iteration.id)
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
        def get(login, token, projectID, id)
            client = Octokit::Client.new(:login => login, :oauth_token => token, :access_token => token)
            issue = client.issue(projectID, id)
            if !label.nil?
                if label.name.include? 'Type'
                    type = label.name[5..-1].downcase
                end
                if label.name.include? 'Priority'
                    priority = label.name[9..-1].downcase
                end
                if label.name.include? 'Status'
                    status = label.name[7..-1].downcase
                end
            end
            if issue.milestone?
                milestone = issue.milestone
            end
            else
                milestone = -1
            end
            return Issue.new(issue.number, issue.title, issue.body, type, priority, status, milestone, -1)
        end

        def add(login, token, projectID, issue)
            client = Octokit::Client.new(:login => login, :oauth_token => token, :access_token => token)
            labels = []
            labels << 'Type:' + issue.type.capitalize
            labels << 'Status:' + issue.status.capitalize
            labels << 'Priority:' + issue.priority.capitalize
            if issue.milestone != -1
                client.create_issue(projectID, issue.title, issue.body, options = {labels: => labels, :milestone => issue.milestone})
            end
            else
                client.create_issue(projectID, issue.title, issue.body, options = {labels: => labels})
            end
        end

    end
end