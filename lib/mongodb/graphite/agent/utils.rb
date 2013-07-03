module Utils
  def self.merge_all
    self.inject({}) { |h1, h2|
      h1.merge! h2
    }
  end

  def self.json_descent(pre, json)
    json.map do |k, v|
      key = pre + [k]
      if v.is_a? BSON::OrderedHash
        json_descent(key, v)
      else
        {key.join('.') => v}
      end
    end
  end

  def self.to_hash(s)
    json_descent([], s).flatten
  end
end
