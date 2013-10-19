require 'eventmachine'

require './queue.rb'

EventMachine.run do
  socket = "socket"
  EventModel::subscribe(:s, nil) do |event|
    puts socket
    puts event.data.to_s
  end

  EventModel::subscribe(:s, "test") do |event|
    puts socket
    puts "1" + event.data.to_s
  end

  event1 = EventModel::Event.new(:e, :s, "test", "Hello")
  puts event1
  event2 = EventModel::Event.new(:e, :s, '#', "World")
  puts event2

  EventModel.raise(event1)
  EventModel.raise(event2)

end
