require 'faraday'
require 'uri'
require 'resolv-replace'

module Scrapers
  class Generic
    def initialize(page)
      @page = page
    end

    def body
      if good_response?
        response.body
      else
        raise InvalidResponseError, "Invalid response status: '#{response.status}'"
      end
    rescue => e
      raise ScraperError, e
    end

    protected

    def good_response?
      response.status.between?(200, 299)
    end

    def query_hash
      {}
    end

    def timeout
      5

    def open_timeout
      2
    end

    private

    attr_reader :page

    def response
      @_response ||= with_retries do
        connection.get do |req|
          req.url path_with_query_string
          req.options.timeout = timeout
          req.options.open_timeout = open_timeout
        end
      end
    end

    def path_with_query_string
      query_string.length > 0 ? "#{path}?#{query_string}" : path
    end

    def query_string
      URI.encode_www_form(query_hash)
    end

    def connection
      @_connection ||= Faraday.new(url: origin) do |faraday|
        faraday.request :url_encoded
        faraday.adapter Faraday.default_adapter
      end
    end
  end

  class ScraperError < StandardError; end
  class InvalidResponseError < ScraperError; end
end
