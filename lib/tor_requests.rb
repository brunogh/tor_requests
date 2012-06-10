require 'net/http'
require 'socksify/http'

class Request

  class << self

    def http(host, port = 80, path = "/")
      res = ""
      Net::HTTP.SOCKSProxy('127.0.0.1', 9050).start(host, port) do |http|
        res = http.get(path)
      end
      res
    end
  
  end

end
   