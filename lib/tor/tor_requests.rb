module Tor
  class << self
    def configuration
      config
    end

    def configure
      config
      yield(configuration)
    end
    
    private
    
    def config
      @onfiguration ||= Configuration.new
    end
    
  end
end