require 'net/http'
require 'socksify/http'

module Tor

  class Configuration

    attr_accessor :ip,
                  :port
    
    def initialize
      @ip = '127.0.0.1'
      @port = 9050
    end    
    
  end

end
