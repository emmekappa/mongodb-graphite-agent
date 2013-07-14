# Mongodb::Graphite::Agent

[![Build Status](https://travis-ci.org/emmekappa/mongodb-graphite-agent.png)](https://travis-ci.org/emmekappa/mongodb-graphite-agent)

Sends MongoDB metrics to Graphite.

## Installation

Add this line to your application's Gemfile:

    gem 'mongodb-graphite-agent'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mongodb-graphite-agent

## Usage

    mongodb-graphite-agent.rb --mongodb-host localhost --graphite-host graphite.local --graphite-port 9090 --graphite-metrics-prefix "localhost.mongodb" --verbose

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
