module Weather
  module Planner
    # Gets the chance of snow within the date range.
    # @param (see #get_planner_response)
    # @return (see #get_chance_of)
    def chance_of_snow(start_date, end_date, location)
      get_chance_of('chanceofsnowday', start_date, end_date, location)
    end

    # Gets the chance of hail within the date range.
    # @param (see #get_planner_response)
    # @return (see #get_chance_of)
    def chance_of_hail(start_date, end_date, location)
      get_chance_of('chanceofhailday', start_date, end_date, location)
    end

    # Gets the chance of temperatures above 0 C/32 F within the date range.
    # @param (see #get_planner_response)
    # @return (see #get_chance_of)
    def chance_of_not_freezing(start_date, end_date, location)
      get_chance_of('tempoverfreezing', start_date, end_date, location)
    end

    # Gets the chance of temperatures below 0 C/32 F within the date range.
    # @param (see #get_planner_response)
    # @return (see #get_chance_of)
    def chance_of_freezing(start_date, end_date, location)
      get_chance_of('tempbelowfreezing', start_date, end_date, location)
    end

    # Gets chance of sultry within the date range.
    # @param (see #get_planner_response)
    # @return (see #get_chance_of)
    def chance_of_sultry(start_date, end_date, location)
      get_chance_of('chanceofsultryday', start_date, end_date, location)
    end

    # Gets the chance of a tornado within the date range.
    # @param (see #get_planner_response)
    # @return (see #get_chance_of)
    def chance_of_tornado(start_date, end_date, location)
      get_chance_of('chanceoftornadoday', start_date, end_date, location)
    end

    # Gets the chance of snow on the ground within the date range.
    # @param (see #get_planner_response)
    # @return (see #get_chance_of)
    def chance_of_groundsnow(start_date, end_date, location)
      get_chance_of('chanceofsnowonground', start_date, end_date, location)
    end

    # Gets the chance of thunderstorms within the date range.
    # @param (see #get_planner_response)
    # @return (see #get_chance_of)
    def chance_of_thunderstorms(start_date, end_date, location)
      get_chance_of('chanceofthunderday', start_date, end_date, location)
    end

    # Gets the chance of temperatures above 32.2 C/90 F within the date range.
    # @param (see #get_planner_response)
    # @return (see #get_chance_of)
    def chance_of_heat(start_date, end_date, location)
      get_chance_of('tempoverninety', start_date, end_date, location)
    end

    # Gets the chance of rain within the date range.
    # @param (see #get_planner_response)
    # @return (see #get_chance_of)
    def chance_of_rain(start_date, end_date, location)
      get_chance_of('chanceofrainday', start_date, end_date, location)
    end

    # Gets the chance of precipitation within the date range.
    # @param (see #get_planner_response)
    # @return (see #get_chance_of)
    def chance_of_precipitation(start_date, end_date, location)
      get_chance_of('chanceofprecip', start_date, end_date, location)
    end

    # Gets the chance of humidity within the date range.
    # @param (see #get_planner_response)
    # @return (see #get_chance_of)
    def chance_of_humid(start_date, end_date, location)
      get_chance_of('chanceofhumidday', start_date, end_date, location)
    end

    # Gets the chance of fog within the date range.
    # @param (see #get_planner_response)
    # @return (see #get_chance_of)
    def chance_of_fog(start_date, end_date, location)
      get_chance_of('chanceoffogday', start_date, end_date, location)
    end

    # Gets the chance of cloudy conditions within the date range.
    # @param (see #get_planner_response)
    # @return (see #get_chance_of)
    def chance_of_cloudy(start_date, end_date, location)
      get_chance_of('chanceofcloudyday', start_date, end_date, location)
    end

    # Gets the chance of sunshine within the date range.
    # @param (see #get_planner_response)
    # @return (see #get_chance_of)
    def chance_of_sunny(start_date, end_date, location)
      get_chance_of('chanceofsunnycloudyday', start_date, end_date, location)
    end

    # Gets the chance of partially cloudy conditions within the date range.
    # @param (see #get_planner_response)
    # @return (see #get_chance_of)
    def chance_of_partlycloudy(start_date, end_date, location)
      get_chance_of('chanceofpartlycloudyday', start_date, end_date, location)
    end

    # Gets the chance of high winds within the date range.
    # @param (see #get_planner_response)
    # @return (see #get_chance_of)
    def chance_of_high_wind(start_date, end_date, location)
      get_chance_of('chanceofwindyday', start_date, end_date, location)
    end

    # Gets the chance of a temperature of 15.5 C/60 F within the date range.
    # @param (see #get_planner_response)
    # @return (see #get_chance_of)
    def chance_of_warmth(start_date, end_date, location)
      get_chance_of('tempoversixty', start_date, end_date, location)
    end

    # Gets the dewpoint highs and lows for the date range.
    # @param (see #get_planner_response)
    # @return [Hash<Symbol, Hash<Symbol, Hash<Symbol, Integer>>>] Highs and lows minimum, average, and maximum for both
    #   metric and imperial systems.
    # @return [String] The error if possible.
    # @todo Raise an error instead of returning a String.
    def get_dewpoints(start_date, end_date, location)
      response = get_planner_response(start_date, end_date, location)
      return response['response']['error'] unless response['response']['error'].nil?
      highs = response['trip']['dewpoint_high']
      lows = response['trip']['dewpoint_low']

      {
        high: {
          imperial: {
            minimum: highs['min']['F'].to_i,
            maximum: highs['max']['F'].to_i,
            average: highs['avg']['F'].to_i
          },
          metric: {
            minimum: highs['min']['C'].to_i,
            maximum: highs['max']['C'].to_i,
            average: highs['avg']['C'].to_i
          }
        },
        low: {
          imperial: {
            minimum: lows['min']['F'].to_i,
            maximum: lows['max']['F'].to_i,
            average: lows['avg']['F'].to_i
          },
          metric: {
            minimum: lows['min']['C'].to_i,
            maximum: lows['max']['C'].to_i,
            average: lows['avg']['C'].to_i
          }
        }
      }
    end

    # Gets the precipitation amounts (not chance) for the date range.
    # @see #get_planner_response
    # @return [Hash<Symbol, Hash<Symbol, Integer>>] Minimum, maximum, and average precipitation quantities for
    #   the location in both inches and centimeters.
    # @return [String] The error if possible.
    # @todo Raise an error instead of returning a String.
    def get_precipitation(start_date, end_date, location)
      response = get_planner_response(start_date, end_date, location)
      return response['response']['error'] unless
        response['response']['error'].nil?
      min = response['trip']['precip']['min']
      avg = response['trip']['precip']['avg']
      max = response['trip']['precip']['max']

      {
        minimum: {
          inch: min['in'].to_i,
          centimeter: min['cm'].to_i
        },
        maximum: {
          inch: max['in'].to_i,
          centimeter: max['cm'].to_i
        },
        average: {
          inch: avg['in'].to_i,
          centimeter: avg['cm'].to_i
        }
      }
    end

    # Gets the highs and lows for the date range.
    # @see #get_planner_response
    # @return [Hash<Symbol, Hash<Symbol, Hash<Symbol, Integer>>>] Highs and lows minimum, average, and maximum for both
    #   metric and imperial systems.
    def get_temperatures(start_date, end_date, location)
      response = get_planner_response(start_date, end_date, location)
      highs = response['trip']['temp_high']
      lows = response['trip']['temp_low']

      {
        high: {
          imperial: {
            minimum: highs['min']['F'].to_i,
            maximum: highs['max']['F'].to_i,
            average: highs['avg']['F'].to_i
          },
          metric: {
            minimum: highs['min']['C'].to_i,
            maximum: highs['max']['C'].to_i,
            average: highs['avg']['C'].to_i
          }
        },
        low: {
          imperial: {
            minimum: lows['min']['F'].to_i,
            maximum: lows['max']['F'].to_i,
            average: lows['avg']['F'].to_i
          },
          metric: {
            minimum: lows['min']['C'].to_i,
            maximum: lows['max']['C'].to_i,
            average: lows['avg']['C'].to_i
          }
        }
      }
    end

    private

    # Gets the full planner API response.
    # @param start_date [DateTime] The date to start at. Only month and day actually matter.
    # @param end_date [DateTime] The date to end at. Only month and day actually matter.
    # @param location [String] The location to get the planner data for.
    # @since 0.5.0
    # @return (see Weatheruby#get)
    def get_planner_response(start_date, end_date, location)
      start = start_date.strftime('%m%d')
      final = end_date.strftime('%m%d')
      get("planner_#{start}#{final}", location)
    end

    # Gets the chance of any given string key in the chance_of hash returned by {#get_planner_response}.
    # @param subject [String] The chance_of hash's key.
    # @param (see #get_planner_response)
    # @since 0.5.0
    # @return [Integer] The chance of the subject happening.
    def get_chance_of(subject, start_date, end_date, location)
      response = get_planner_response(start_date, end_date, location)

      response['trip']['chance_of'][subject]['percentage'].to_i
    end
  end
end
