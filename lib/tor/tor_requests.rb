# frozen_string_literal: true

# This class allows to define a configuration for Tor
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
      @config ||= Configuration.new
    end
  end
end
