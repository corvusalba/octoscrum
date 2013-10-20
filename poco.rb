class User
    attr_accessor :id
    attr_accessor :login
    attr_accessor :children

    def initialize(id, login, children)
        @id = id
        @login = login
        @type = 'user'
        @parent = -1
        @children = children
    end
end