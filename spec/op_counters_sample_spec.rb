require 'rspec'
require 'mongodb/graphite/agent/op_counters_sample'

describe 'OpCounters' do
  it 'should reload last sample' do
    current_sample = Mongodb::Graphite::Agent::OpCountersSample.new(100)

    File.open('lastsample-test', 'w') do |file|
      Marshal.dump(current_sample, file)
    end

    File.open('lastsample-test', 'r') do |file|
      previous_sample = Marshal.load(file)
      previous_sample.values.should eq(100)
    end
  end
end