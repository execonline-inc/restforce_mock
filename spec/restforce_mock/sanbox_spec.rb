require 'spec_helper'

describe RestforceMock::Sandbox do
  context "get_object" do
    it "gets the object" do
      name = "Contact"
      id = "some id"
      values = { Name: "Name here" }
      RestforceMock::Sandbox.add_object(name, id, values)

      expect(RestforceMock::Sandbox.get_object(name, id)).to eq values
    end
  end

  context do
    before do
      RestforceMock::Sandbox.reset!
    end

    after do
      RestforceMock::Sandbox.reset!
    end

    it 'should add object to sandbox storage' do
      name = "Contact"
      id = "some id"
      values = { Name: "Name here" }
      RestforceMock::Sandbox.add_object(name, id, values)

      s = RestforceMock::Sandbox.send(:storage)
      expect(s[name][id]).to eq values
    end

    it 'should update values in sandbox' do
      name = "Contact"
      id = "some id"
      values = { Name: "Name here", Location: "Somewhere"}
      RestforceMock::Sandbox.add_object(name, id, values)
      RestforceMock::Sandbox.update_object(name, id, { Location: "None" })

      s = RestforceMock::Sandbox.send(:storage)
      expect(s[name][id]).to eq values.merge( Location: "None" )
    end

  end

  it 'should reset the sandbox' do
    name = "Contact"
    id = "some id"
    values = { Name: "Name here" }
    RestforceMock::Sandbox.add_object(name, id, values)

    RestforceMock::Sandbox.reset!

    s = RestforceMock::Sandbox.send(:storage)
    expect(s).to eq ({})
  end
end
