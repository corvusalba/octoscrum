require 'sinatra'
require 'sinatra/static_assets'
require 'thin'
require 'eventmachine'
require 'em-websocket'

configure do
  #set :views, ['views/layouts', 'views/pages', 'views/partials']
  # sets root as the parent-directory of the current file
  set :root, File.join(File.dirname(__FILE__), '..')
  # sets the view directory correctly
  set :views, Proc.new { File.join(root, "views") }
end

#Dir["./app/models/*.rb"].each { |file| require file }
#Dir["./app/helpers/*.rb"].each { |file| require file }
#Dir["./app/controllers/*.rb"].each { |file| require file }
#Dir["./app/*.rb"].each { |file| require file }
require './web.rb'
require './socket.rb'

def run(options)
  EM.run do
    server = options[:server] || 'thin'
    host = options[:host] || '0.0.0.0'
    port = options[:port] || '8080'
    wsport = options[:wsport] || '8081'
    web_app = options[:app]

    dispatch = Rack::Builder.app do
                              map '/' do
                                run web_app
                              end
                            end

    Rack::Server.start({
                      app: dispatch,
                      server: server,
                      Host: host,
                      Port: port
                      })

    EM::WebSocket.run(:host => host, :port => wsport) do |socket|
      context = SocketContext.new(socket)
      socket.onopen do |handshake|
        context.open(handshake)
      end
      socket.onclose { context.close }
      socket.onmessage { |msg| context.message(msg) }
    end
  end
end

run app: WebController.new
