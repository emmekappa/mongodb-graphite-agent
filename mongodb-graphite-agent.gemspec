# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongodb/graphite/agent/version'

Gem::Specification.new do |spec|
  spec.name          = "mongodb-graphite-agent"
  spec.version       = Mongodb::Graphite::Agent::VERSION
  spec.authors       = ["Michele Cantelli"]
  spec.email         = ["michele.cantelli@jobrapido.com"]
  spec.description   = ""
  spec.summary       = ""
  spec.homepage      = "https://github.com/emmekappa/mongodb-graphite-agent"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency 'mongo'
  spec.add_dependency 'simple-graphite'
  spec.add_dependency 'bson'
  spec.add_dependency 'bson_ext'
  spec.add_dependency 'awesome_print'
  spec.add_dependency 'time_difference'
  spec.add_dependency 'trollop'
end
