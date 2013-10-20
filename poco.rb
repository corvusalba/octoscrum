class Project
    attr_accessor :id
    attr_accessor :title
    attr_accessor :user
    attr_accessor :org
    attr_accessor :children

    def initialize(id, title, maintainer)
        @id = id
        @title = title
        @type = 'project'
        @maintainer = maintainer
        @children = nil
    end
end

class Iteration
    attr_accessor :id
    attr_accessor :title
    attr_accessor :description
    attr_accessor :due_on
    attr_accessor :parent
    attr_accessor :children

    def initialize(id, title, parent, children)
        @id = id
        @title = title
        @description = description
        @due_on = due_on
        @type = 'iteration'
        @parent = parent
        @children = children
    end
end

class Issue
    attr_accessor :id
    attr_accessor :title
    attr_accessor :body
    attr_accessor :type
    attr_accessor :priority
    attr_accessor :status
    attr_accessor :parent
    attr_accessor :children

    def initialize(id, title, body, type, priority, status, parent, children)
        @id = id
        @title = title
        @body = body
        @type = type
        @priority = priority
        @status = status
        @parent = parent
        @children = children
    end
end
