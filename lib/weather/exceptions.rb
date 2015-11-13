module Weather
  module Exceptions
    class TooManyResultsError < StandardError
      def message
        'There were too many locations given in the response. Please narrow ' \
        'down your query.'
      end
    end
  end
end
