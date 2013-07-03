#!/usr/bin/env ruby

$:.unshift File.absolute_path("#{File.dirname(__FILE__)}/../lib")

require 'trollop'
require "mongodb/graphite/agent"

opts = Trollop::options do
  opt :mongodb_username, "MongoDB username", :type => :string
  opt :mongodb_host, "MongoDB host", :type => :string, :default => "localhost"
  opt :mongodb_post, "MongoDB host", :type => :int, :default => 27017
  opt :mongodb_password, "MongoDB password", :type => :string
  opt :graphite_host, "Graphite host", :type => :string
  opt :graphite_port, "Graphite port", :type => :string
end

Mongodb::Graphite::Agent.run(opts)
