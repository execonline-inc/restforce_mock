module RestforceMock
  module Sandbox

    def self.add_object(name, id, values)
      if storage[name] && !storage[name][id].nil?
        raise "Object #{name} with #{id} exists"
      end
      storage[name].merge!({ id  => values })
    end

    def add_object(name, id, values)
      RestforceMock::Sandbox.add_object(name, id, values)
    end

    def get_object(name, id)
      RestforceMock::Sandbox.get_object(name, id)
    end

    def self.get_object(name, id)
      storage[name][id]
    end

    def get_object_from_query(query)
      RestforceMock::Sandbox.find_object(query)
    end

    def self.find_object(query)
      # This will only support making queries in this format:
      # client.query("Select Id FROM Contact WHERE Email = 'debrah.obrian@yahoo.com'")

      split_query = query.split

      storage_name = split_query[3]
      key = "#{split_query[5]}".to_sym
      val = split_query.last
                  .gsub(/^'|'$/, '')
                  .gsub('\\', '')

      if storage[storage_name].has_value?( key => val)
        return storage[storage_name].keys.first
      end
    end

    def self.update_object(name, id, attrs)
      current = storage[name][id]
      storage[name][id] = current.merge(attrs)
    end

    def update_object(name, id, attrs)
      RestforceMock::Sandbox.update_object(name, id, attrs)
    end

    def self.reset!
      $restforce_mock_storage = initialize
    end

    def self.storage
      $restforce_mock_storage ||= initialize
    end

    #Private
    def self.update_schema(object_name)
      s = RestforceMock::SchemaManager.new
      storage[:schema][object_name] = s.get_schema(object_name)
    end

    def self.client
      ::Restforce.new
    end

    def self.initialize
      storage = Hash.new do |hash, object|
        hash[object]={}
      end
      storage[:schema] = Hash.new do |hash, object|
        hash[object]={}
      end
    end

    def self.validate_all_present_fields!(current, attrs)
      missing = attrs.keys - current.keys
      unless missing.length == 0
        raise Faraday::Error::ResourceNotFound.new(
          "INVALID_FIELD_FOR_INSERT_UPDATE: Unable to create/update fields: #{missing}." +
          " Please check the security settings of this field and verify that it is " +
          "read/write for your profile or permission set")
      end
    end

  end
end
