module Weather
  module Actions
    # Gets alert information for a location.
    # @param location [String] The place to get the alert data for.
    # @return [Hash/String] Nil if there are no alerts, or a hash of hashes
    #   containing relevant data if not. Each array in the hash contains
    #   information for a different alert.
    def alerts(location)
      response = get('alerts', location)
      ret = []
      count = 0
      response['alerts'].each do |a|
        ret[count] = {
          type: a['type'],
          description: a['description'],
          date: a['date'],
          expires: a['expires'],
          message: a['message']
        }
        count += 1
      end

      ret
    end

    # Gets the current moon phase of the location.
    # @param location [String] The place to get the phase for.
    # @return [Hash/String] A hash of two integers for the moon phase
    #   information. The age key in the hash contains the moon's age in days,
    #   and the illumination key contains the percentage of how illuminated it
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
    # @return [Hash] A hash containing strings of relevant weather information.
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
    # @return [Hash] A hash containing a few integers of data.
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
    # @return [Hash] A hash containing a few integers of data.
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

    # Gets data for currently-happening hurricanes around the world.
    # @return [Hash] A hash containing hashes of data. Each sub-hash is named
    #   as the "nice" name for the hurricane (example: Hurricane Daniel).
    def hurricane_data
      response = get('currenthurricane', 'view')

      ret = {}
      response['currenthurricane'].each do |h|
        ret[h['stormInfo']['stormName_Nice']] = {
          name: h['stormInfo']['stormName'],
          number: h['stormInfo']['stormNumber'],
          category: h['Current']['Category'],
          time: h['Current']['Time']['pretty'],
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

    # Gets more complicated forecast information for the location. Only gets
    #   the forecast for the next three days.
    # @param location [String] The place to get the forecast for.
    # @return [Hash] A hash containing hashes of information. Sub-hashes are
    #   named as their "period", or the day in relation to the current day.
    #   For example: 0 is today, 1 is tomorrow, etc. It does not organize itself
    #   by weekday. Unlike simple_forecast, you do not get very many strings in
    #   this method.
    def complex_forecast(location)
      response = get('forecast', location)

      parse_complex_forecast(response)
    end

    # Exactly the same as #simple_forecast, except that it gets the data for
    #   10 days.
    def simple_forecast_10day(location)
      response = get('forecast10day', location)

      parse_simple_forecast(response)
    end

    # Exactly the same as #complex_forecast, except that it gets the data for
    #   10 days.
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
        ret[f['period'] - 1] = {
          high_f: f['high']['fahrenheit'].to_i,
          high_c: f['high']['celsius'].to_i,
          low_f: f['low']['fahrenheit'].to_i,
          low_c: f['low']['celsius'].to_i,
          conditions: f['conditions'].to_i,
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
