module Mongo

  class MongoClient
    def is_replicaset?
      begin
        cmd = BSON::OrderedHash.new
        cmd["replSetGetStatus"] = 1
        result = self.db("admin").command(cmd)
        return !result["set"].blank?
      rescue Mongo::OperationFailure
        return false
      end
    end
  end
end
