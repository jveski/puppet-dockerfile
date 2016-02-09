require 'spec_helper'

describe Puppet::Type.type(:parent_image) do
  it "should throw an error for an invalid osfamily" do
    expect {
      described_class.new(:name => 'foo', :osfamily => 'bar')
    }.to raise_error(/is not a supported/)
  end

  it "should allow the enterprise linux osfamily" do
    expect {
      described_class.new(:name => 'foo', :osfamily => 'el')
    }.to_not raise_error
  end
end
