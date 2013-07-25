require 'rspec'
require 'mongodb/graphite/agent/collection_size_calculator'
require 'mongo'

describe 'Collection size calculator' do
  it 'should calculate the number of documents in all db collections' do
    connection = Mongo::MongoClient.new()
    connection["test"]["lol"].save({ asd: 1})
    collection_size_calculator = Mongodb::Graphite::Agent::CollectionSizeCalculator.new(connection)
    collection_size_calculator.calculate.should have_at_least(1).items
  end
end