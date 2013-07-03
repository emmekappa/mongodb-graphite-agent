require 'rubygems'
require 'mongo'
require 'simple-graphite'
require 'bson'
require 'socket'
require 'awesome_print'
require 'time_difference'
require 'op_counters_sample'

module Utils
  def to_hash(s)
    json_descent([], s).flatten
  end

  def json_descent(pre, json)
    json.map do |k, v|
      key = pre + [k]
      if v.is_a? BSON::OrderedHash
        json_descent(key, v)
      else
        {key.join('.') => v}
      end
    end
  end

  def merge_all
    self.inject({}) { |h1, h2|
      h1.merge! h2
    }
  end

  module_function :to_hash, :json_descent, :merge_all

end

@connection = Mongo::MongoClient.new("localhost", 27017, :slave_ok => true)

@hash = @connection["local"].command('serverStatus' => 1)


@g = Graphite.new({:host => "localhost", :port => 2003})

#puts @hash["connections"]["current"]
#puts @hash["connections"]["available"]
#
#puts @hash["backgroundFlushing"]["average_ms"]
#
#puts @hash["network"]["numRequests"]
#puts @hash["network"]["bytesIn"]
#puts @hash["network"]["bytesOut"]
#
#
#puts @hash["cursors"]["totalOpen"]
#
#puts @hash["indexCounters"]["missRatio"]

@asd = Utils.to_hash(@hash) #all metrics


#ap(@asd)


@current_sample = OpCountersSample.new Hash[@hash["opcounters"]]
@previous_sample = nil

if(File.exist? 'lastsample')
  File.open('lastsample', 'r') do |file|
    @previous_sample = Marshal.load(file)
    #puts "Loaded object"
    #ap(@previous_sample)
  end
end

puts "Delta: "
@delta = DateTime.parse(@current_sample.sample_time) - DateTime.parse(@previous_sample.sample_time)
TimeDifference
puts @delta.to_s

@previous_sample.values.keys.sort.each do |k|
  puts "#{k}: #{@previous_sample.values[k]} / #{@current_sample.values[k]}"
end

File.open('lastsample', 'w') do |file|
  Marshal.dump(@current_sample, file)
end



@g.send_metrics({"#{Socket.gethostname}.connections.current" => @hash["connections"]["current"]})

