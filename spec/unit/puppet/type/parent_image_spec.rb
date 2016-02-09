require 'spec_helper'

describe Puppet::Type.type(:parent_image) do
  it "should set the correct osfamily given a centos image of a specific version" do
    result = described_class.new(:name => 'centos:7')
    expect(result.parameters[:osfamily].value).to eq('el')
  end

  it "should set the correct osfamily given a centos image" do
    result = described_class.new(:name => 'centos')
    expect(result.parameters[:osfamily].value).to eq('el')
  end
  it "should set the correct osfamily given a ubuntu image of a specific version" do
    result = described_class.new(:name => 'ubuntu:12.4.5')
    expect(result.parameters[:osfamily].value).to eq('debian')
  end

  it "should set the correct osfamily given a ubuntu image" do
    result = described_class.new(:name => 'ubuntu')
    expect(result.parameters[:osfamily].value).to eq('debian')
  end

  it "should allow the user to override the osfamily" do
    result = described_class.new(:name => 'centos', :osfamily => 'foo')
    expect(result.parameters[:osfamily].value).to eq('foo')
  end
end
