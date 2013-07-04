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
      class Runner

        def initialize(opts)
          @opts = opts
        end

        def run
          connection = Mongo::MongoClient.new(@opts.mongodb_host, @opts.mongodb_port, :slave_ok => true)
          unless (@opts[:mongodb_username].blank? && @opts[:mongodb_password].blank?)
            connection["admin"].authenticate(@opts.mongodb_username, @opts.mongodb_password)
          end

          server_status_result = connection["local"].command('serverStatus' => 1)
          metric_hash = Utils.to_hash(server_status_result).select { |k|
            k.match('^connection|^network\.|^cursors|^mem\.mapped|^indexCounters|^repl.oplog')
          }

          opcounters_per_second_metric_hash = calculate_opcounters_per_second server_status_result["opcounters"]

          if @opts[:verbose]
            puts "Calculating metrics..."
            ap metric_hash
            ap opcounters_per_second_metric_hash
          end



          unless (@opts[:dry_run])
            graphite_writer = GraphiteWriter.new(@opts[:graphite_host], @opts[:graphite_port], @opts[:verbose])
            graphite_writer.write(metric_hash)
            graphite_writer.write(opcounters_per_second_metric_hash)
          end
        end

        def calculate_opcounters_per_second(opcounters)
          current_sample = OpCountersSample.new Hash[opcounters]
          previous_sample = current_sample.dup
          result = {}

          if File.exist? 'lastsample'
            File.open('lastsample', 'r') do |file|
              previous_sample = Marshal.load(file)
            end
          end

          delta = TimeDifference.between(Time.parse(current_sample.sample_time), Time.parse(previous_sample.sample_time))
          puts "Last sample was taken #{delta.in_seconds.round(0)} seconds ago"

          previous_sample.values.keys.sort.each do |k|
            previous_sample_value = previous_sample.values[k]
            current_sample_value = current_sample.values[k]
            value_per_seconds = ((current_sample_value - previous_sample_value) / delta.in_seconds).round(2)
            result["#{k}_per_seconds"] = value_per_seconds
          end

          File.open('lastsample', 'w') do |file|
            Marshal.dump(current_sample, file)
          end

          result
        end
      end
    end
  end
end