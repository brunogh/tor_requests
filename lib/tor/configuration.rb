require 'net/http'
require 'socksify/http'

module Tor

  class Configuration

    attr_accessor :ip,
                  :port

    attr_reader :headers

    def add_header(header, value)
      @headers[header] = value
    end

    def initialize
      @ip      = '127.0.0.1'
      @port    = 9050
      @headers = Hash.new
    end

  end

end
