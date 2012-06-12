require 'net/http'
require 'socksify/http'

module Tor

  class HTTP

    def self.get(host, path = "/", port = 80)
      res = ""
      Net::HTTP.SOCKSProxy(Tor.configuration.ip, Tor.configuration.port).start(host, port) do |http|
        res = http.get(path)
      end
      res
    end
  
  end

end
   