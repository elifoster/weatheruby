require 'httpclient'
require 'json'
require_relative 'actions'

class Weatheruby
  include Weather::Actions

  # Creates a new instance of Weatheruby.
  # @param api_key [String] Your personal API key obtained on sign up for
  #   Weather Underground.
  # @param language [String] The language code you would like to use.
  # @param use_pws [Boolean] Whether to use the Personal Weather Station
  #   feature.
  # @param use_bestfct [Boolean] Whether to use BestForecast.
  def initialize(api_key, language = 'EN', use_pws = true, use_bestfct = true)
    @api_key = api_key
    @language_key = language.upcase
    @use_pws = use_pws ? 1 : 0
    @use_bestfct = use_bestfct ? 1 : 0

    @client = HTTPClient.new
  end

  # Performs a generic HTTP GET request. This method should generally not be
  #   used by a standard user, unless there is not a method for a particular
  #   action/feature.
  # @param feature [String] The "feature" parameter defined by Wunderground.
  # @param location [String] The location of the query.
  # @param autoparse [Boolean] Whether to automatically parse the response.
  # @return [JSON/HTTPMessage] Parsed JSON if true, or raw response if not.
  def get(feature, location, autoparse = true)
    url = "http://api.wunderground.com/api/#{@api_key}/#{feature}/lang:" \
          "#{@language_key}/pws:#{@use_pws}/bestfct:#{@use_bestfct}/q/" \
          "#{location}.json"
    url = URI.encode(url)
    uri = URI.parse(url)
    res = @client.get(uri)

    if autoparse
      return JSON.parse(res.body)
    else
      return res
    end
  end
end
