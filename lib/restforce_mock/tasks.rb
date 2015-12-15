require "rake"

namespace :restforce_mock do
  namespace :schema do
    desc "Dump schema from Salesforce into file"
    task load: :environment  do
      m = RestforceMock::SchemaManager.new
      m.dump_schema(
        RestforceMock.configuration.objects_for_schema,
        RestforceMock.configuration.schema_file
      )
    end
  end
end
