# encoding: utf-8

module BitcoinCourseMonitoring
  module Services
    module Exmo
      class PairSettings
        class << self
          URL = 'https://api.exmo.com/v1/pair_settings'.freeze

          def pair_settings
            response = RestClient.get(URL) { |resp, _request, _result| resp }
            JSON.parse(response.body, symbolize_names: true)
          rescue => e
            error = "#{e.class}: #{e.message}:\n  #{e.backtrace.first}"
            $logger.error { error }
            { error: error }
          end
        end
      end
    end
  end
end
