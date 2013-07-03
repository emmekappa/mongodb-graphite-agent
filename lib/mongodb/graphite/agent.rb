require 'rubygems'
require 'bundler/setup'
require 'mongo'
require 'simple-graphite'
require 'bson'
require 'socket'
require 'awesome_print'
require 'time_difference'
require 'mongodb/graphite/agent/utils'
require 'mongodb/graphite/agent/op_counters_sample'

module Mongodb
  module Graphite
    module Agent
      def self.run
        @connection = Mongo::MongoClient.new("localhost", 27017, :slave_ok => true)

        @hash = @connection["local"].command('serverStatus' => 1)


        @g = ::Graphite.new({:host => "localhost", :port => 2003})

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
        @previous_sample = @current_sample.dup

        if File.exist? 'lastsample'
          File.open('lastsample', 'r') do |file|
            @previous_sample = Marshal.load(file)
            #puts "Loaded object"
            #ap(@previous_sample)
          end
        end

        puts "Delta: "
        @delta = TimeDifference.between(Time.parse(@current_sample.sample_time), Time.parse(@previous_sample.sample_time))
        puts @delta.in_seconds

        @previous_sample.values.keys.sort.each do |k|
          previous_sample_value = @previous_sample.values[k]
          current_sample_value = @current_sample.values[k]
          value_per_seconds = ((current_sample_value - previous_sample_value) / @delta.in_seconds).round(2)
          puts "#{k}: #{previous_sample_value} / #{current_sample_value}: #{value_per_seconds}/s"
        end

        File.open('lastsample', 'w') do |file|
          Marshal.dump(@current_sample, file)
        end

        #@g.send_metrics({"#{Socket.gethostname}.connections.current" => @hash["connections"]["current"]})
      end
    end
  end
end
