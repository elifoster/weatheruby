require 'httpclient'
require 'json'
require_relative 'weather/actions'
require_relative 'weather/planner'

class Weatheruby
  class WeatherError < StandardError; end

  include Weather::Actions
  include Weather::Planner

  attr_accessor :language_key

  # Creates a new instance of Weatheruby.
  # @param api_key [String] Your personal API key obtained on sign up for Weather Underground.
  # @param language [String] The language code you would like to use.
  # @param use_pws [Boolean] Whether to use the Personal Weather Station feature.
  # @param use_bestfct [Boolean] Whether to use BestForecast.
  def initialize(api_key, language = 'EN', use_pws = true, use_bestfct = true)
    @api_key = api_key
    @language_key = language.upcase
    @use_pws = use_pws ? 1 : 0
    @use_bestfct = use_bestfct ? 1 : 0

    @client = HTTPClient.new
  end

  private

  # Performs a generic HTTP GET request. This method should generally not be used by a standard user, unless there is
  # not a method for a particular action/feature.
  # @param feature [String] The "feature" parameter defined by Wunderground.
  # @param location [String] The location of the query.
  # @param autoparse [Boolean] Whether to automatically parse the response.
  # @return [Hash/HTTPMessage] Parsed JSON if autoparse is true, or raw response if not.
  # @raise WeatherError if anything goes wrong with the API, or it returns too many results for us to handle.
  def get(feature, location, autoparse = true)
    url = "http://api.wunderground.com/api/#{@api_key}/#{feature}/lang:" \
          "#{@language_key}/pws:#{@use_pws}/bestfct:#{@use_bestfct}/q/" \
          "#{location}.json"
    url = URI.encode(url)
    uri = URI.parse(url)
    res = @client.get(uri)
    json = JSON.parse(res.body)
    if json['response'].key?('error')
      fail(WeatherError, json['response']['error']['type'] + ': ' + json['response']['error']['description'].capitalize)
    end
    if json['response'].key?('results')
      fail(WeatherError, 'toomanyresults: Too many results were returned. Try narrowing your search.')
    end


    autoparse ? json : res
  end
end
