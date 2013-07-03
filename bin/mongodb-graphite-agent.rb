#!/usr/bin/env ruby

$:.unshift File.expand_path("#{File.dirname(__FILE__)}/../lib")

require 'trollop'
require 'mongodb/graphite/agent'
require 'mongodb/graphite/agent/graphite_writer'

opts = Trollop::options do
  opt :mongodb_username, "MongoDB username", :type => :string
  opt :mongodb_host, "MongoDB host", :type => :string, :default => "localhost"
  opt :mongodb_post, "MongoDB host", :type => :int, :default => 27017
  opt :mongodb_password, "MongoDB password", :type => :string
  opt :graphite_host, "Graphite host", :type => :string
  opt :graphite_port, "Graphite port", :type => :string
  opt :dry_run, "Dry run", :type => :boolean, :default => false
  opt :verbose, "Verbose", :type => :boolean, :default => false
end

if opts[:dry_run]
  puts "\n\nWARNING!!! This is a dry run\n\n\n"
  sleep 1
end

#@writer = Mongodb::Graphite::Agent::GraphiteWriter.new("localhost", 12)
#@writer.write ({ "antani" => 5, "boh" => 1 })
Mongodb::Graphite::Agent.run(opts)
