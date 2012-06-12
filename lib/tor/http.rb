require 'net/http'
require 'socksify/http'

module Tor

  class HTTP

    def self.get(uri_or_host, path = nil, port = nil)
      res = ""
      host = nil
      if path
        host = uri_or_host
      else
        host = uri_or_host.hostname
        port = uri_or_host.port
      end
      Net::HTTP.SOCKSProxy(Tor.configuration.ip, Tor.configuration.port).start(host, port) do |http|
        res = http.get(path || uri_or_host.path)
      end
      res
    end
  
  end

end
   