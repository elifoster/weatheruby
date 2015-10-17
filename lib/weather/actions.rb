module Weather
  module Actions
    # Gets alert information for a location.
    # @param location [String] The place to get the alert data for.
    # @return [Hash/Nil] Nil if there are no alerts, or a hash of hashes
    #   containing relevant data if not. Each array in the hash contains
    #   information for a different alert.
    def alerts(location)
      response = get('alerts', location)
      if response['alerts'].nil?
        return nil
      else
        ret = []
        count = 0
        response['alerts'].each do |a|
          ret[count] = {
            :type => a['type'],
            :description => a['description'],
            :date => a['date'],
            :expires => a['expires'],
            :message => a['message'],
          }
          count += 1
        end
      end

      ret
    end

    # Gets the current moon phase of the location.
    # @param location [String] The place to get the phase for.
    # @return [Hash] A hash of two integers for the moon phase information.
    #   The age key in the hash contains the moon's age in days, and the
    #   illumination key contains the percentage of how illuminated it is.
    def moon_phase(location)
      response = get('astronomy', location)
      ret = {}
      ret[:age] = response['moon_phase']['ageOfMoon'].to_i
      ret[:illumination] = response['moon_phase']['percentIlluminated'].to_i

      ret
    end

    # Gets weather conditions for the location.
    # @param location [String] The place to get the weather report for.
    # @return [Hash] A hash containing strings of relevant weather information.
    def conditions(location)
      response = get('conditions', location)
      current_observation = response['current_observation']
      display_location = current_observation['display_location']

      ret = {
        :full_name => display_location['full'],
        :city_name => display_location['city'],
        :state_abbreviation => display_location['state'],
        :state_name => display_location['state_name'],
        :country => display_location['country'],
        :zip_code => display_location['zip'].to_i,
        :updated => current_observation['observation_time'],
        :weather => current_observation['weather'],
        :formatted_temperature => current_observation['temperature_string'],
        :temperature_f => current_observation['temp_f'],
        :temperature_c => current_observation['temp_c'],
        :humidity => current_observation['relative_humidity'],
        :formatted_wind => current_observation['wind_string'],
        :wind_direction => current_observation['wind_dir'],
        :wind_degrees => current_observation['wind_degrees'],
        :wind_speed => current_observation['wind_mph'],
        :wind_gust_speed => current_observation['wind_gust_mph'].to_i,
        :formatted_feelslike => current_observation['feelslike_string'],
        :feelslike_f => current_observation['feelslike_f'].to_i,
        :feelslike_c => current_observation['feelslike_c'].to_i
      }

      ret[:humidity] = ret[:humidity].sub('%', '').to_i

      ret
    end
  end
end
