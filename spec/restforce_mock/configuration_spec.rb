
describe RestforceMock do
  let(:client) { RestforceMock::Client.new }

  describe "#configure" do
    before do
      RestforceMock.reset
    end

    it "set schema file" do
      RestforceMock.configure do |config|
        config.schema_file = "tmp"
      end

      expect( RestforceMock.configuration.schema_file ).to eq "tmp"
    end

    describe "raise_on_schema_missing" do
      it "false by default" do
        expect( RestforceMock.configuration.raise_on_schema_missing).to eq false
      end

      it "sets to true" do
        RestforceMock.configure do |config|
          config.raise_on_schema_missing = true
        end

        expect( RestforceMock.configuration.raise_on_schema_missing).to eq true
      end
    end

    describe "error_on_required" do

      it "set to true" do
        RestforceMock.configure do |config|
          config.error_on_required = true
        end

        expect( RestforceMock.configuration.error_on_required ).to eq true
      end

      it "sets to true by default" do
        expect( RestforceMock.configuration.error_on_required ).to eq true
      end
    end

    it "doesn't set schema file by default" do
      expect( RestforceMock.configuration.schema_file ).to be_nil
    end
  end
end
