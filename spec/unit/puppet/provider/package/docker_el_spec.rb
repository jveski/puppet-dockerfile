require 'spec_helper'

describe Puppet::Type.type(:package).provider(:docker_el) do
  context "when given a package name without version" do
    subject { Puppet::Type.type(:package).new(
      :provider => :docker_el,
      :name     => 'foo',
      :ensure   => 'present',
    ).provider}

    let(:context) { StubContext.for 'el' }

    it "should return the correct string" do
      result = subject.dockerfile_line(context)
      expect(result).to eq("CMD yum install foo")
    end
  end

  context "when given a package name with version" do
    subject { Puppet::Type.type(:package).new(
      :provider => :docker_el,
      :name     => 'foo',
      :ensure   => 'bar',
    ).provider}

    let(:context) { StubContext.for 'el' }

    it "should return the correct string" do
      result = subject.dockerfile_line(context)
      expect(result).to eq("CMD yum install foo-bar")
    end
  end
end
