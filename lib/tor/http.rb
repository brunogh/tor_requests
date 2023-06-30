# frozen_string_literal: true

require "net/http"
require "socksify/http"

module Tor
  # This class wraps SOCKS proxy around Net::HTTP
  class HTTP
    class TooManyRedirects < StandardError; end

    class << self
      attr_accessor :redirects_made
    end

    def self.get(uri_or_host, path = nil, port = nil, max_redirects = 3)
      self.redirects_made = 0

      if path
        host = uri_or_host
      else
        host = uri_or_host.host
        port = uri_or_host.port
      end

      get_with_socks_proxy(uri_or_host, host, port, path, max_redirects)
    end

    def self.post(uri_or_host, post_options = {}, path = nil, port = nil)
      if path
        host = uri_or_host
      else
        host = uri_or_host.host
        port = uri_or_host.port
        path = uri_or_host.request_uri
      end

      post_with_socks_proxy(uri_or_host, host, port, path, post_options)
    end

    def self.start_socks_proxy(start_params, &block)
      Net::HTTP.SOCKSProxy(Tor.configuration.ip, Tor.configuration.port).start(*start_params) do |http|
        block.call(http)
      end
    end

    def self.get_with_socks_proxy(uri_or_host, host, port, path, max_redirects)
      start_params = start_parameters(uri_or_host, host, port)
      start_socks_proxy(start_params) do |http|
        request = Net::HTTP::Get.new(path || uri_or_host)
        Tor.configuration.headers.each do |header, value|
          request.delete(header)
          request.add_field(header, value)
        end

        res = http.request(request)

        follow_redirect(res, http, max_redirects)
      end
    end

    def self.post_with_socks_proxy(uri_or_host, host, port, path, post_options)
      start_params = start_parameters(uri_or_host, host, port)
      start_socks_proxy(start_params) do |http|
        request = Net::HTTP::Post.new(path)
        request.set_form_data(post_options)

        Tor.configuration.headers.each do |header, value|
          request.delete(header)
          request.add_field(header, value)
        end

        http.request(request)
      end
    end

    def self.start_parameters(uri_or_host, host, port)
      uri_or_host = URI.parse(uri_or_host) if uri_or_host.is_a? String

      [
        host, port,
        { use_ssl: uri_or_host.scheme == "https",
          verify_mode: OpenSSL::SSL::VERIFY_NONE }
      ]
    end

    def self.follow_redirect(response, http, max_redirects)
      return response unless response.is_a?(Net::HTTPRedirection)

      raise TooManyRedirects if redirects_made >= max_redirects

      request = Net::HTTP::Get.new(fetch_redirect_url(response))
      response = http.request(request)
      self.redirects_made += 1

      follow_redirect(response, http, max_redirects)
    end

    # Get the redirect url from the response.
    # It searches in the "location" header and response body
    def self.fetch_redirect_url(response)
      return response.body.match(/<a href="([^>]+)">/i)[1] if response["location"].nil?

      response["location"]
    end
  end
end
