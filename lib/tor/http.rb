require 'net/http'
require 'socksify/http'

module Tor

  class HTTP
    class TooManyRedirects < StandardError; end

    class << self
      attr_accessor :redirects_made
    end

    def self.get(uri_or_host, path = nil, port = nil, max_redirects = 3)
      res, host = "", nil
      self.redirects_made = 0

      if path
        host = uri_or_host
      else
        host = uri_or_host.host
        port = uri_or_host.port
      end

      start_params = start_parameters(uri_or_host, host, port)
      start_socks_proxy(start_params) do |http|
        request = Net::HTTP::Get.new(path || uri_or_host.path)
        Tor.configuration.headers.each do |header, value|
          request.delete(header)
          request.add_field(header, value)
        end

        res = http.request(request)
        res = follow_redirect(res, http, max_redirects) # Follow redirects
      end

      res
    end

    def self.post(uri_or_host, post_options = {}, path = nil, port = nil)
      res, host = "", nil
      if path
        host = uri_or_host
      else
        host = uri_or_host.host
        port = uri_or_host.port
        path = uri_or_host.request_uri
      end

      start_params = start_parameters(uri_or_host, host, port)
      start_socks_proxy(start_params) do |http|
        request = Net::HTTP::Post.new(path)
        request.set_form_data(post_options)
        Tor.configuration.headers.each do |header, value|
          request.delete(header)
          request.add_field(header, value)
        end
        res = http.request(request)
      end

      res
    end

    private

    def self.start_socks_proxy(start_params, &code_block)
      Net::HTTP.SOCKSProxy(Tor.configuration.ip, Tor.configuration.port).
        start(*start_params) { |http| code_block.call(http) }
    end

    def self.start_parameters(uri_or_host, host, port)
      uri_or_host = URI.parse(uri_or_host) if uri_or_host.is_a? String
      [
        host, port,
        :use_ssl     => uri_or_host.scheme == 'https',
        :verify_mode => OpenSSL::SSL::VERIFY_NONE
      ]
    end

    def self.follow_redirect(response, http, max_redirects)
      if response.kind_of?(Net::HTTPRedirection)
        raise TooManyRedirects if self.redirects_made >= max_redirects
        request  = Net::HTTP::Get.new(fetch_redirect_url(response))
        response = http.request(request)
        self.redirects_made += 1
        response = follow_redirect(response, http, max_redirects)
      else
        response
      end

    end

    # Get the redirect url from the response.
    # It searches in the "location" header and response body
    def self.fetch_redirect_url(response)
      if response['location'].nil?
        response.body.match(/<a href=\"([^>]+)\">/i)[1]
      else
        response['location']
      end
    end

  end

end

