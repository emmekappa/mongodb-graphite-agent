require 'awesome_print'

module Mongodb
  module Graphite
    module Agent
      class CollectionSizeCalculator

        def initialize(mongo_client)
          @mongo_client = mongo_client
        end

        def calculate
          collection_count_hash = {}
          @mongo_client.database_names.each { |db_name|
            @mongo_client[db_name].collection_names.each { |collection_name|


              collection_count_hash["collection_sizes.#{db_name}.#{collection_name}"] = @mongo_client[db_name][collection_name].stats()["count"]
            } unless db_name == 'local'
          }

          return collection_count_hash
        end

      end
    end
  end
end
