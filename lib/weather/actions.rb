require 'time'

module Weather
  module Actions
    # Gets alert information for a location.
    # @param location [String] The place to get the alert data for.
    # @return [Array<Hash<Symbol, String>>] A list of alerts for the given location. The array will be empty if there
    #   are no alerts. Each value in the array is a hash containing symbol keys:
    #
    #   * `:type` (`String`) — The 3 character identifier for the alert type (see Wunderground API docs)
    #   * `:description` (`String`) — The full name of the alert type
    #   * `:date` (`Time`) — The date that the alert begins to take effect, using the local timezone to this location.
    #   * `:expires` (`Time`) — The date that the alert is no longer in effect, using the local timezone to this location.
    #   * `:message` (`String`) — The full message for the alert (this is usually dozens of paragraphs long)
    def alerts(location)
      response = get('alerts', location)
      ret = []
      count = 0
      response['alerts'].each do |a|
        ret[count] = {
          type: a['type'],
          description: a['description'],
          date: Time.parse(a['date']),
          expires: Time.parse(a['expires']),
          message: a['message']
        }
        count += 1
      end

      ret
    end

    # Gets the current moon phase of the location.
    # @param location [String] The place to get the phase for.
    # @return [Hash<Symbol, Integer>] A hash of two integers for the moon phase
    #   information. The `:age` key in the hash contains the moon's age in days,
    #   and the `:illumination` key contains the percentage of how illuminated it
    #   is.
    def moon_phase(location)
      response = get('astronomy', location)
      {
        age: response['moon_phase']['ageOfMoon'].to_i,
        illumination: response['moon_phase']['percentIlluminated'].to_i
      }
    end

    # Gets sunrise and sunset information for the current day at the current location.
    # @param location [String] The place to get the info for.
    # @return [Hash<Symbol, Hash<Symbol, Integer>>] A hash containing two hashes at keys :rise and :set for sunrise
    #   and sunset information respectively. They each contain an :hour key and a :minute key which point to the hour
    #   and minute that the sun will rise or set.
    def sun_info(location)
      response = get('astronomy', location)
      {
        rise: {
          hour: response['moon_phase']['sunrise']['hour'].to_i,
          minute: response['moon_phase']['sunrise']['minute'].to_i
        },
        set: {
          hour: response['moon_phase']['sunset']['hour'].to_i,
          minute: response['moon_phase']['sunset']['minute'].to_i
        }
      }
    end

    # Gets weather conditions for the location.
    # @param location [String] The place to get the weather report for.
    # @return [Hash<Symbol, Object>] A hash containing strings of relevant weather information. It contains the
    #   following keys:
    #
    #   * `:full_name` (`String`) — The full name of the location
    #   * `:city_name` (`String`) — The name of the city
    #   * `:state_abbreviation` (`String`) — The abbreviation for the state (or national equivalent)
    #   * `:state_name` (`String`) — The name of the state (or national equivalent)
    #   * `:country` (`String`) — The name of the country
    #   * `:zip_code` (`Integer`) — The zip code for this location
    #   * `:updated` (`String`) — A string describing the date for when this data was last updated.
    #   * `:weather` (`String`) — A brief description of the current weather conditions in this location (e.g., Partly
    #   Cloudy)
    #   * `:formatted_temperature` (`String`) — The formatted temperature as provided by the API. It does not contain °
    #   symbols. Its format is "XX F (YY C)"
    #   * `:temperature_f` (`Float`) — The current temperature in fahrenheit
    #   * `:temperature_c` (`Float`) — The current temperature in celsius
    #   * `:humidity` (`Integer`) — The humidity percentage
    #   * `:formatted_wind` (`String`) — A brief description of the current wind conditions (e.g., Calm)
    #   * `:wind_direction` (`String`) — The direction (East, West, etc.) that the wind is blowing
    #   * `:wind_degrees` (`Integer`) — The angle of the wind
    #   * `:wind_speed` (`Float`) — The speed of the wind in miles per hour
    #   * `:wind_gust_speed` (`Integer`) — The speed of the gusts of wind in miles per hour
    #   * `:formatted_feelslike` (`String`) — The formatted string for the "feels like" temperature data as provided
    #   by the API. See :formatted_temperature for the format.
    #   * `:feelslike_f` (`Integer`) — The temperature that it feels like (not always the same as the temperature it
    #   is) in fahrenheit
    #   * `:feelslike_c` (`Integer`) — Like feelslike_f but in celsius
    def conditions(location)
      response = get('conditions', location)
      current_observation = response['current_observation']
      display_location = current_observation['display_location']

      ret = {
        full_name: display_location['full'],
        city_name: display_location['city'],
        state_abbreviation: display_location['state'],
        state_name: display_location['state_name'],
        country: display_location['country'],
        zip_code: display_location['zip'].to_i,
        updated: current_observation['observation_time'],
        weather: current_observation['weather'],
        formatted_temperature: current_observation['temperature_string'],
        temperature_f: current_observation['temp_f'],
        temperature_c: current_observation['temp_c'],
        humidity: current_observation['relative_humidity'],
        formatted_wind: current_observation['wind_string'],
        wind_direction: current_observation['wind_dir'],
        wind_degrees: current_observation['wind_degrees'],
        wind_speed: current_observation['wind_mph'],
        wind_gust_speed: current_observation['wind_gust_mph'].to_i,
        formatted_feelslike: current_observation['feelslike_string'],
        feelslike_f: current_observation['feelslike_f'].to_i,
        feelslike_c: current_observation['feelslike_c'].to_i
      }

      ret[:humidity] = ret[:humidity].sub('%', '').to_i

      ret
    end

    # Gets the record low for the location.
    # @param location [String] The place to get the record low for.
    # @return [Hash<Symbol, Integer>] A hash containing a few integers of data:
    #
    #   * `:average_low_f` (`Integer`) — The average low temperature in this location in fahrenheit
    #   * `:average_low_c` (`Integer`) — The average low temperature in this location in celsius
    #   * `:record_year` (`Integer`) — The year in which this location had its lowest temperatures
    #   * `:record_low_f` (`Integer`) — The lowest temperature this location has had in fahrenheit
    #   * `:record_low_c` (`Integer`) — The lowest temperature this location has had in celsius
    def record_low(location)
      response = get('almanac', location)
      {
        average_low_f: response['almanac']['temp_low']['normal']['F'].to_i,
        average_low_c: response['almanac']['temp_low']['normal']['C'].to_i,
        record_year: response['almanac']['temp_low']['recordyear'].to_i,
        record_low_f: response['almanac']['temp_low']['record']['F'].to_i,
        record_low_c: response['almanac']['temp_low']['record']['C'].to_i
      }
    end

    # Gets the record high for the location.
    # @param location [String] The place to get the record high for.
    # @return [Hash<Symbol, Integer>] A hash containing a few integers of data:
    #
    #   * `:average_high_f` (`Integer`) — The average high temperature in this location in fahrenheit
    #   * `:average_high_c` (`Integer`) — The average high temperature in this location in celsius
    #   * `:record_year` (`Integer`) — The year in which this location had its highest temperatures
    #   * `:record_high_f` (`Integer`) — The highest temperature this location has had in fahrenheit
    #   * `:record_high_c` (`Integer`) — The highest temperature this location has had in celsius
    def record_high(location)
      response = get('almanac', location)
      {
        average_high_f: response['almanac']['temp_high']['normal']['F'].to_i,
        average_high_c: response['almanac']['temp_high']['normal']['C'].to_i,
        record_year: response['almanac']['temp_high']['recordyear'].to_i,
        record_high_f: response['almanac']['temp_high']['record']['F'].to_i,
        record_high_c: response['almanac']['temp_high']['record']['C'].to_i
      }
    end

    # Gets data for currently-happening storms around the world.
    # @return [Hash<String, Hash<Symbol, String/Integer>>] A hash containing hashes of data. Each sub-hash is named
    #   as the name for the storm including the type (example: Hurricane Daniel). The sub-hash values are as follows:
    #
    #   * `:name` (`String`) — The name of the hurricane (example: Daniel)
    #   * `:number` (`String`) — The ID of the storm, 8 characters with a 2 letter basin ID.
    #   * `:category` (`String`) — The type of storm according to the Saffir-Simpson scale.
    #   * `:time` (`Time`) — The time the storm is recorded to start or have started using the local timezone for this
    #   location.
    #   * `:wind_speed_mph` (`Integer`) — The speed of the wind in this storm in miles per hour.
    #   * `:wind_speed_kts` (`Integer`) — The speed of the wind in this storm in knots.
    #   * `:wind_speed_kph` (`Integer`) — The speed of the wind in this storm in kilometers per hour.
    #   * `:gust_speed_mph` (`Integer`) — The speed of the gusts of wind in this storm in miles per hour.
    #   * `:gust_speed_kts` (`Integer`) — The speed of the gusts of wind in this storm in knots.
    #   * `:gust_speed_kph` (`Integer`) — The speed of the gusts of wind in this storm in kilometers per hour.
    def hurricane_data
      begin
        response = get('currenthurricane', 'view')
      rescue Weatheruby::WeatherError => e
        # For some reason the API always errors with this when getting current hurricane data.
        fail e unless e.message.start_with?('querynotfound')
        response = e.full_response
      end
      p response

      ret = {}
      response['currenthurricane'].each do |h|
        ret[h['stormInfo']['stormName_Nice']] = {
          name: h['stormInfo']['stormName'],
          number: h['stormInfo']['stormNumber'],
          category: h['Current']['Category'],
          time: Time.parse(h['Current']['Time']['pretty']),
          wind_speed_mph: h['Current']['WindSpeed']['Mph'],
          wind_speed_kts: h['Current']['WindSpeed']['Kts'],
          wind_speed_kph: h['Current']['WindSpeed']['Kph'],
          gust_speed_mph: h['Current']['WindGust']['Mph'],
          gust_speed_kts: h['Current']['WindGust']['Kts'],
          gust_speed_kph: h['Current']['WindGust']['Kph']
        }
      end

      ret
    end

    # Gets the basic forecast information for the location. Only gets data
    #   for the next 3 days.
    # @param location [String] The place to get the forecast for.
    # @return [Hash] A hash containing hashes of information. Sub-hashes are
    #   named as their "period", or the day in relation to the current day.
    #   For example: 0 is today, 1 is tomorrow, etc. It does not organize itself
    #   by weekday. That is what the weekday_name key is for.
    def simple_forecast(location)
      response = get('forecast', location)

      parse_simple_forecast(response)
    end

    # Gets more complicated forecast information for the location. Only gets the forecast for the next three days.
    # @param location [String] The place to get the forecast for.
    # @return [Hash] A hash containing hashes of information. Sub-hashes are named as their "period", or the day in
    #   relation to the current day. For example: 0 is today, 1 is tomorrow, etc. It does not organize itself by
    #   weekday. Unlike simple_forecast, you do not get very many strings in this method.
    def complex_forecast(location)
      response = get('forecast', location)

      parse_complex_forecast(response)
    end

    # Exactly the same as {#simple_forecast}, except that it gets the data for 10 days.
    # @param (see #simple_forecast)
    # @return (see #simple_forecast)
    def simple_forecast_10day(location)
      response = get('forecast10day', location)

      parse_simple_forecast(response)
    end

    # Exactly the same as {#complex_forecast}, except that it gets the data for 10 days.
    # @param (see #complex_forecast)
    # @return (see #complex_forecast)
    def complex_forecast_10day(location)
      response = get('forecast10day', location)

      parse_complex_forecast(response)
    end

    private

    # Parses the simple forecast information.
    def parse_simple_forecast(response)
      ret = {}

      response['forecast']['txt_forecast']['forecastday'].each do |f|
        ret[f['period']] = {
          weekday_name: f['title'],
          text: f['fcttext'],
          text_metric: f['fcttext_metric'],
          image_url: f['icon_url']
        }
      end

      ret
    end

    # Parses the complex forecast information.
    def parse_complex_forecast(response)
      ret = {}

      response['forecast']['simpleforecast']['forecastday'].each do |f|
        date = f['date']
        ret[f['period'] - 1] = {
          date: DateTime.new(date['year'], date['month'], date['day'], date['hour'], date['min'].to_i, date['sec'], date['tz_short']),
          weekday_name: date['weekday'],
          high_f: f['high']['fahrenheit'].to_i,
          high_c: f['high']['celsius'].to_i,
          low_f: f['low']['fahrenheit'].to_i,
          low_c: f['low']['celsius'].to_i,
          conditions: f['conditions'].to_i,
          image_url: f['icon_url'],
          snow: {
            snow_total_in: f['snow_allday']['in'],
            snow_total_cm: f['snow_allday']['cm'],
            snow_night_in: f['snow_night']['in'],
            snow_night_cm: f['snow_night']['cm'],
            snow_day_in: f['snow_day']['in'],
            snow_day_cm: f['snow_day']['cm']
          },
          quantative_precipitation: {
            qpf_total_in: f['qpf_allday']['in'],
            qpf_total_cm: f['qpf_allday']['cm'],
            qpf_night_in: f['qpf_night']['in'],
            qpf_night_cm: f['qpf_night']['cm'],
            qpf_day_in: f['qpf_day']['in'],
            qpf_day_cm: f['qpf_day']['cm']
          },
          wind: {
            average_mph: f['avewind']['mph'],
            average_kph: f['avewind']['kph'],
            average_dir: f['avewind']['dir'],
            average_temp: f['avewind']['degrees'],
            max_mph: f['maxwind']['mph'],
            max_kph: f['maxwind']['kph'],
            max_dir: f['maxwind']['dir'],
            max_temp: f['maxwind']['degrees']
          }
        }
      end

      ret
    end
  end
end
