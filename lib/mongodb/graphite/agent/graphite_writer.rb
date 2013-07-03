

class Hash
  def hash_map
    self.inject({}) do |newhash, (k,v)|
      newhash[k] = yield(k, v)
      newhash
    end
  end
end

module Mongodb
  module Graphite
    module Agent
      class GraphiteWriter
        def initialize(host, port, verbose)
          @graphite = ::Graphite.new({:host => host, :port => port})
          @verbose = verbose
        end

        def write(metric_hash)
          puts "Sending data to graphite" if @verbose
          ap metric_hash if @verbose
          @metric_hash_with_hostname = metric_hash.map { |k, v| { "#{Socket.gethostname}.#{k}" => v } }.reduce Hash.new(), :merge
          @graphite.send_metrics @metric_hash_with_hostname
          #ap metric_hash.hash_map { |k, v| { "#{Socket.gethostname}.#{k}" => v }}

          #@graphite.send_metrics({"#{Socket.gethostname}.#{metric}" => value})
        end
      end
    end
  end
end
