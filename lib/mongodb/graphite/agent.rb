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
      def self.run(opts)
        @connection = Mongo::MongoClient.new(opts.mongodb_host, opts.mongodb_port, :slave_ok => true)
        unless(opts[:mongodb_username].blank? && opts[:mongodb_password].blank?)
          @connection["admin"].authenticate(opts.mongodb_username, opts.mongodb_password)
        end

        @hash = @connection["local"].command('serverStatus' => 1)

        @graphite_writer = GraphiteWriter.new(opts[:graphite_host], opts[:graphite_port], opts[:verbose])

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


        @current_sample = OpCountersSample.new Hash[@hash["opcounters"]]
        @previous_sample = @current_sample.dup

        if File.exist? 'lastsample'
          File.open('lastsample', 'r') do |file|
            @previous_sample = Marshal.load(file)
            #puts "Loaded object"
            #ap(@previous_sample)
          end
        end

        @delta = TimeDifference.between(Time.parse(@current_sample.sample_time), Time.parse(@previous_sample.sample_time))
        puts "Last sample was taken #{@delta.in_seconds.round(0)} seconds ago" if opts[:verbose]

        @previous_sample.values.keys.sort.each do |k|
          previous_sample_value = @previous_sample.values[k]
          current_sample_value = @current_sample.values[k]
          value_per_seconds = ((current_sample_value - previous_sample_value) / @delta.in_seconds).round(2)
          puts "#{k}: #{previous_sample_value} / #{current_sample_value}: #{value_per_seconds}/s" if opts[:verbose]
        end

        File.open('lastsample', 'w') do |file|
          Marshal.dump(@current_sample, file)
        end

        @graphite_writer.write( @asd.select {|k| k.match('^connection|^network\.|^cursors|^mem\.mapped|^indexCounters|^repl.oplog') } )
        #@graphite_writer.write("connections.current" => @hash["connections"]["current"]) unless(opts[:dry_run])
      end
    end
  end
end
class GraphiteWriter

end