require 'epitools'
require 'socket'

module MF
  SOCKFILE = "/tmp/motherforker"

  def fork_server
    if File.exists? SOCKFILE
      false
    else
      fork {
        MF::Server.new.run
      }
    end
  end

  def self.connect
    UNIXSocket.new SOCKFILE
  end

  class Server
    def initialize
      @sock = UNIXServer.new(SOCKFILE)
    end

    def run
      handle @sock.accept
    end

    def handle(fd)
      command, *args = fd.gets.split
      send(command, *args) if self.responds_to?(command)
    end
  end

end
