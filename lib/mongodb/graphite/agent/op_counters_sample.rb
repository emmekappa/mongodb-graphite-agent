require 'date'

module Mongodb
  module Graphite
    module Agent

      class OpCountersSample
        attr_reader :values, :sample_time

        def initialize(values, sample_time = DateTime.now.to_s)
          @values = values
          @sample_time = sample_time
        end

        def marshal_dump
          [@sample_time, @values]
        end

        def marshal_load array
          @sample_time, @values = array
        end

      end
    end
  end
end