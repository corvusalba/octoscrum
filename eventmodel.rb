require 'eventmachine'
require 'amqp'
require 'json'

module EventModel
  $host = '127.0.0.1'

  class EventModel::Event
    attr_reader :eventType
    attr_reader :screenType
    attr_reader :screenId
    attr_reader :data

    def initialize(eventType, screenType, screenId, data)
      @eventType = eventType
      @screenType = screenType
      @screenId = screenId
      @data = data
    end

    def Event.parse(payload)
      hash = JSON.parse(payload)
      return Event.new(hash["eventType"], hash["screenType"],hash["screenId"], hash["data"])
    end

    def serialize
      return {:eventType => @eventType, :screenType => @screenType, :screenId => @screenId, :data => @data}.to_json
    end
  end

  def EventModel.subscribe(screenType, screenId)
    AMQP.connect(:host => $host) do |connection, openok|
      channel = AMQP::Channel.new(connection)
      routingKey = screenId != nil ? screenId.to_s : "#"
      exchange = channel.topic(screenType.to_s)
      channel.queue("").bind(exchange, :routing_key => routingKey).subscribe do |payload|
            yield Event.parse(payload)
      end
    end
  end

  def EventModel.raise(event)
    AMQP.connect(:host => $host) do |connection, openok|
      routingKey = event.screenId != nil ? event.screenId.to_s : "#"
      channel = AMQP::Channel.new(connection)
      exchange = channel.fanout(event.screenType.to_s)
      exchange.publish('1234', :routing_key => routingKey)
    end
  end
end
