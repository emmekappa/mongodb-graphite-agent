module Mongodb
  module Graphite
    module Agent
      class GraphiteWriter
        def initialize(host, port, verbose)
          @graphite = ::Graphite.new({:host => host, :port => port})
          @verbose = verbose
        end

        def write(metric_hash)
          @metric_hash_with_hostname = Hash[metric_hash.map { |k,v| ["#{Socket.gethostname}.mongodb.#{k}", v]}]
          if @verbose
            puts "Sending data to graphite..."
            ap @metric_hash_with_hostname
          end
          @graphite.send_metrics @metric_hash_with_hostname
        end
      end
    end
  end
end
