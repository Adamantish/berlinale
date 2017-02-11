require 'faraday'
require 'uri'
require 'resolv-replace'

module Scrapers
  class Generic
    def initialize(page)
      @page = page
    end

    def data
      if success?
        response.body
      else
        fail InvalidResponseError, "Invalid response status: '#{response.status}'"
      end
    rescue => e
      raise ScrapingError, e
    end

    protected

    def success?
      response.status.between?(200, 299)
    end

    def origin
      fail NotImplementedError
    end

    def path
      fail NotImplementedError
    end

    def query_hash
      {}
    end

    def timeout
      5 # seconds
    end

    def open_timeout
      2 # seconds
    end

    def max_retries
      5
    end

    def retry_wait
      5 # seconds
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

    def with_retries(&block)
      res = nil

      max_retries.times do |try_no|
        res = block.call
        break if res.status == 403
        return res if res.status <= 299 || res.status == 404

        sleep retry_wait if try_no < max_retries - 1
      end

      fail ScrapingError, "Fetching '#{path}' failed with #{res.status} error."
    end

    def connection
      @_connection ||= Faraday.new(url: origin) do |faraday|
        faraday.request :url_encoded
        faraday.adapter Faraday.default_adapter
      end
    end
  end

  class ScrapingError < StandardError; end
  class InvalidResponseError < ScrapingError; end
end
