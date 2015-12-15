require 'spec_helper'

describe RestforceMock do
  let(:client) { RestforceMock::Client.new }

  describe "version" do
    it 'has a version number' do
      expect(RestforceMock::VERSION).not_to be nil
    end
  end

  context do
    before do
      RestforceMock::Sandbox.reset!
    end

    after do
      RestforceMock::Sandbox.reset!
    end

    it 'should add object to sandbox though client' do
      name = "Contact"
      id = "some id"
      values = { Name: "Name here" }
      RestforceMock::Client.new.add_object(name, id, values)

      s = RestforceMock::Sandbox.send(:storage)
      expect(s[name][id]).to eq values
    end

    it 'should update values in sandbox' do
      name = "Contact"
      id = "some id"
      values = { Name: "Name here", Location: "Somewhere"}
      RestforceMock::Client.new.add_object(name, id, values)
      RestforceMock::Sandbox.update_object(name, id, { Location: "None" })

      s = RestforceMock::Sandbox.send(:storage)
      expect(s[name][id]).to eq values.merge( Location: "None" )
    end

    describe "validate_presence!" do
      it "should validate presence" do
        name = "Contact"
        id = "some id"
        values = { Name: "Name here" }

        client.add_object(name, id, values)
        client.validate_presence!(name, id)
      end

      it "should throw an exception if id is not present" do
        name = "Contact"
        id = "some id"
        values = { Name: "Name here" }

        expect {
          client.validate_presence!(name, id)
        }.to raise_error Faraday::ResourceNotFound, /Provided external ID field does not/
      end
    end

    describe "api_patch" do

      it "raises error if schema is missing" do
        expect(RestforceMock.configuration).to(
          receive(:raise_on_schema_missing) { true }
        )

        id = "HGUKK674J79HjsH"
        values = {
          Name: "Name here",
          Program__c: "1234",
          Section_Name__c: "12345"
        }
        RestforceMock::Sandbox.add_object("Object__c", id, values)

        expect {
          client.api_patch("/sobjects/Object__c/#{id}", values)
        }.to raise_error /Schema file is not defined/
      end

      it "validates required fields" do
        id = "HGUKK674J79HjsH"
        values = {
          Name: "Name here",
          Program__c: "1234",
          Section_Name__c: "12345"
        }
        RestforceMock::Sandbox.add_object("Object__c", id, values)

        new_values = {
          Name: "New Name",
          Program__c: "91233",
        }
        client.api_patch("/sobjects/Object__c/#{id}", new_values)
        o = RestforceMock::Sandbox.get_object("Object__c", id)
        expect(o[:Program__c]).to eq("91233")
        expect(o[:Name]).to eq("New Name")
      end
    end

    describe "api_post" do

      it "raises error if schema file is missing" do
        expect(RestforceMock.configuration).to(
          receive(:raise_on_schema_missing) { true }
        )

        expect {
          values = { Name: "Name here" }
          body = client.api_post("/sobjects/Contact", values)
        }.to raise_error /Schema file is not defined/
      end

      it "raises error if schema for an object is missing" do
        expect(RestforceMock.configuration).to(
          receive(:raise_on_schema_missing) { true }
        )
        expect(RestforceMock.configuration).to(
          receive(:schema_file) {
            "spec/fixtures/required_schema.yml"
          }
        )

        expect {
          values = { Name: "Name here" }
          body = client.api_post("/sobjects/Contact", values)
        }.to raise_error /No schema for Salesforce object Contact/
      end

      it "mock out POST request" do
        values = { Name: "Name here" }
        body = client.api_post("/sobjects/Contact", values)
        id= body.body["id"]

        s = RestforceMock::Sandbox.send(:storage)
        expect(s["Contact"][id]).to eq values
      end

      context "errors on required is enabled" do
        it "validates required fields" do
          expect(RestforceMock.configuration).to(
            receive(:schema_file) {
              "spec/fixtures/required_schema.yml"
            }
          ).at_least(:once)

          values = { Name: "Name here" }
          expect {
            client.api_post("/sobjects/Object__c", values)
          }.to raise_error Faraday::ResourceNotFound,
          /REQUIRED_FIELD_MISSING: Required fields are missing: \[:Program__c, :Section_Name__c\]/
        end

      end

      context "errors on required are disabled" do
        before do
          RestforceMock.configure do |config|
            config.schema_file = "spec/fixtures/required_schema.yml"
            config.error_on_required = false
          end
        end

        it "doesn't validate required fields" do

          values = { Name: "Name here" }
          expect {
            client.api_post("/sobjects/Object__c", values)
          }.not_to raise_error
        end
      end

    end
  end

end
