require 'spec_helper'

describe Puppet::Type.type(:file).provider(:docker) do
  it "should raise an error if no source is provided" do
    expect {
      Puppet::Type.type(:file).new(
        :provider => :docker,
        :title    => '/tmp/test',
        :ensure   => 'present',
      ).provider.dockerfile_line(nil)
    }.to raise_error(/parameters be provided/)
  end

  it "should raise an error if source is not an absolute path" do
    expect {
      Puppet::Type.type(:file).new(
        :provider => :docker,
        :title    => '/tmp/test',
        :source   => ['file:foo'],
        :ensure   => 'present',
      ).provider.dockerfile_line(nil)
    }.to raise_error(/Cannot use opaque URLs/)
  end

  it "should return the correct dockerfile line" do
    line = Puppet::Type.type(:file).new(
      :provider => :docker,
      :title    => '/tmp/foo',
      :source   => ['file:/tmp/bar'],
      :ensure   => 'present',
    ).provider.dockerfile_line(nil)

    expect(line).to eq('ADD /tmp/bar /tmp/foo')
  end
end
