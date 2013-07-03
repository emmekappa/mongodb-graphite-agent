#!/usr/bin/env ruby
$:.unshift File.absolute_path("#{File.dirname(__FILE__)}/../lib")
puts $LOAD_PATH
require "mongodb/graphite/agent"

Mongodb::Graphite::Agent.run()
#Agent.run()
