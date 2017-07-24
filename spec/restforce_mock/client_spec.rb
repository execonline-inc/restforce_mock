require 'spec_helper'

describe RestforceMock do
  let(:client) { RestforceMock::Client.new }

  context "initialization" do
    it "allows for initialization options" do
      RestforceMock::Client.new({some: :opt})
    end
  end
end
