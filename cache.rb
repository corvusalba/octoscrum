require 'memcached'
require 'active_record'

class User < ActiveRecord::Base
end

class Repo < ActiveRecord::Base
end

class Iter < ActiveRecord::Base
end

class UserStory < ActiveRecord::Base
end

class Bug < ActiveRecord::Base
end

class Task < ActiveRecord::Base
end

class MyAbstractModel
	def initialize item
		@item = item
	end

	def set
		set_cache(@item, @item.id) 
	end

	def get
		get_cache(@item.id)
	end
end

# # get all Persons from in-memory storage...
# p MyAbstractModel.new(:Person, :in_memory_store)
# # ...and from a database
# p MyAbstractModel.new(:Person, :active_record)


CACHE = Memcached.new("localhost:11211")

def get_cache(key)
	data = CACHE.get(key)
	return data unless data.nil?
	
	data = ﬁnd_on_git(key)
	set_cache(key, data)
	return data
end

def set_cache(key, value)
	CACHE.set(key, value, 60)
end

def update_cache(key, value)
	CACHE.delete(key)
	set_cache(key, value)
end

class User
	def get
		self
	end
	
end

set_cache("111", "333")
puts get_cache("111")
update_cache("111", "444")
puts get_cache("111")
