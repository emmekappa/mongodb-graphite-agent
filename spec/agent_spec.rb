require 'rspec'
require 'mongodb/graphite/agent'

describe 'MongoDB Server Status' do

  it 'should read server status' do

    #To change this template use File | Settings | File Templates.
    runner = Mongodb::Graphite::Agent::Runner.new({ :mongodb_host => 'localhost', :mongodb_port => '27017', :dry_run => true, :verbose => true})
    runner.run

  end
end