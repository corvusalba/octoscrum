require 'eventmachine'
require 'em-websocket'
require './eventmodel.rb'

class SocketContext
  def initialize(socket)
    @socket = socket
    @screenType = nil
    @screenId = nil
  end

  def open(handshake)
  end

  def close()
  end

  def send(event)
    @socket.send event.serialize
  end

  def message(msg)
    event = EventModel::Event.parse(msg)
    if event.eventType == 'subscribe'
      @screenType = event.screenType
      @screenId = event.screenId
      EventModel.subscribe(@screenType, @screenId) do |event|
        self.send event
      end
    else
      EventModel.raise(event)
    end
  end
end
