module Weather
  module Actions
    # Gets alert information for a location.
    # @param location [String] The place to get the alert data for.
    # @return [Hash/Nil] Nil if there are no alerts, or a hash of arrays
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
    # @return []
    def moon_phase(location)
      response = get('astronomy', location)
      ret = {}
      ret[:age] = response['moon_phase']['ageOfMoon'].to_i
      ret[:illumination] = response['moon_phase']['percentIlluminated'].to_i

      ret
    end
  end
end
