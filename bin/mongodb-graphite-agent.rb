#!/usr/bin/env ruby

$:.unshift File.expand_path("#{File.dirname(__FILE__)}/../lib")

require 'trollop'
require 'mongodb/graphite/agent'

opts = Trollop::options do
  opt :mongodb_username, "MongoDB username", :type => :string
  opt :mongodb_host, "MongoDB host", :type => :string, :default => "localhost"
  opt :mongodb_post, "MongoDB host", :type => :int, :default => 27017
  opt :mongodb_password, "MongoDB password", :type => :string
  opt :graphite_host, "Graphite host", :type => :string
  opt :graphite_port, "Graphite port", :type => :string
  opt :graphite_metrics_prefix, "Graphite metrics prefix", :type => :string, :default => Socket.gethostname
  opt :dry_run, "Dry run", :type => :boolean, :default => false
  opt :verbose, "Verbose", :type => :boolean, :default => false
end

if opts[:dry_run]
  puts "\n\nWARNING!!! This is a dry run\n\n\n"
  sleep 1
end

Trollop::die :graphite_host, "(or --dry-run) must be specified" if (opts[:graphite_host].blank? and opts[:dry_run].blank?)

runner = Mongodb::Graphite::Agent::Runner.new(opts)
runner.run