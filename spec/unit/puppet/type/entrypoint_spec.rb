require 'spec_helper'

describe Puppet::Type.type(:entrypoint) do
  it "should allow the user to set the entrypoint command" do
    result = described_class.new(:name => 'foo')
    expect(result.parameters[:command].value).to eq('foo')
  end
end
