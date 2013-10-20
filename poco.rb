class User
    attr_accessor :id
    attr_accessor :children

    def initialize(id, children)
        @id = id
        @type = 'user'
        @parent = -1
        @children = children
    end
end

class Project
    attr_accessor :id
    attr_accessor :title
    attr_accessor :org
    attr_accessor :children

    def initialize(id, title, user, org)
        @id = id
        @title = title
        @type = 'project'
        @user = user
        @org = org
        @children = nil
    end
end
