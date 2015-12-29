# RestforceMock

  - [![Build](http://img.shields.io/travis-ci/ilyakatz/restforce_mock.svg?style=flat-square)](https://travis-ci.org/execonline-inc/restforce_mock)
  - [![Version](http://img.shields.io/gem/v/restforce_mock.svg?style=flat-square)](https://rubygems.org/gems/restforce_mock)
  - [![License](http://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat-square)](http://opensource.org/licenses/MIT)

Mock out [Restforce](https://github.com/ejholmes/restforce) in tests

## Installation

Add this line to your application's Gemfile:

```ruby
group :development, :test do

  gem 'restforce_mock'

end
```

_Note_: You may elect to add it to the `:test` group only if you do not want to
use rake task as described below

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install restforce_mock

## Usage

To mock out Restforce global in your test environment

```ruby
Restforce = RestforceMock::Client
```

This will direct all calls to `Restforce` to `RestforceMock`. Test as usual.

### Configuration

```ruby
RestforceMock.configure do |config|
  config.schema_file = "spec/fixtures/schema.yml"

  # raise error if required field is not set (default: true)
  config.error_on_required = true
  config.required_exclusions = [:LastModifiedById ...] # fields that should not be considered required

  # raise error if schema is not available (default: false)
  config.raise_on_schema_missing = true

  # objects in SF that should be loaded into the schema used for RestforceMock
  config.objects_for_schema = ["Contact", "Opportunity" ...]
end
```

### Salesforce Schema

If you decide to use `config.schema_file` you will need to load schema from Salesforce.

Restforce_mock comes with a rake task

```ruby
require 'organizations/tasks'
task "restforce_mock:schema:dump"
```

Rake task requires environmental variables set up as described [here](https://github.com/ejholmes/restforce#usernamepassword-authentication)

You can now run

`rake restforce_mock:schema:dump`

#### Rails

If you environment (eg. Rails) setups salesforce variables

```ruby
require 'organizations/tasks'
task "restforce_mock:schema:dump" => :environment
```

### Mimicking Salesforce data

To mimic Salesforce database, add some data to the `RestfoceMock` sandbox

```ruby
  RestforceMock::Sandbox.add_object("Contact", "HGUKK674J79HjsH", { Name__c: "John" })
```

To access the object in the RestforceMock object

```ruby
  RestforceMock::Sandbox.get_object("Contact", "HGUKK674J79HjsH")
```

RestforceMock sandbox is **shared across all your tests** (same way as real Salesforce instace would be), hence,
after completion of tests make sure to clean up if necessary

```ruby
  RestforceMock::Sandbox.reset!
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/restforce_mock. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## Dedication

This gem is dedicated to the memory of Adrian P.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

