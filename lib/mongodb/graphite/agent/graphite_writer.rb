module Mongodb
  module Graphite
    module Agent
      class GraphiteWriter
        def initialize(opts)
          @graphite = ::Graphite.new({:host => opts[:host], :port => opts[:port]})
          @opts = opts
        end

        def write(metric_hash)
          @metric_hash_with_hostname = Hash[metric_hash.map { |k,v| ["#{@opts[:metrics_prefix]}.#{k}", v]}]
          if @opts[:verbose]
            puts "Sending data to graphite..."
            ap @metric_hash_with_hostname
          end
          @graphite.send_metrics @metric_hash_with_hostname
        end
      end
    end
  end
end
