require 'spec_helper'

describe "the dockerfile function" do
  it "raises an error if the provider doesn't have a dockerfile method" do
    Puppet::Type.newtype(:test) do
      newparam(:name) do
      end
    end

    Puppet::Type.type(:test).provide(:docker_bar) do
    end

    pp = <<-MANIFEST
    parent_image { 'foo':
      osfamily => 'bar',
    }

    test { 'baz': }
    MANIFEST

    expect{ dockerfile(pp) }.to raise_error(/doesn't implement a dockerfile/)
  end

  it "raises an error if the provider's dockerfile method returns an array" do
    Puppet::Type.newtype(:test) do
      newparam(:name) do
      end
    end

    Puppet::Type.type(:test).provide(:docker_bar) do
      def dockerfile(context)
        []
      end
    end

    pp = <<-MANIFEST
    parent_image { 'foo':
      osfamily => 'bar',
    }

    test { 'baz': }
    MANIFEST

    expect{ dockerfile(pp) }.to raise_error(/didn't return a string/)
  end

  it "raises an error when given a single file resource" do
    pp = <<-MANIFEST
    package { 'test':
      ensure => present,
    }
    MANIFEST

    expect{ dockerfile(pp) }.to raise_error(/parent_image resource declaration was not/)
  end

  it "raises an error given an unsupported resource declaration" do
    pp = <<-MANIFEST
    parent_image { 'centos:7':
      osfamily => 'el',
    }

    user { 'foo':
      ensure => present,
    }
    MANIFEST

    expect{ dockerfile(pp) }.to raise_error(/lacks the appropriate provider/)
  end

  it "allows access to variables in the parent scope" do
    result = compile(<<-MANIFEST)
    $test = "foo"

    $dockerfile = dockerfile() || {
      parent_image { $test:
        osfamily => 'el',
      }
    }

    file { '/test':
      ensure  => present,
      content => $dockerfile,
    }
    MANIFEST

    expect(result).to eq("FROM foo\n")
  end

  it "returns the correct string given a parent_image resource" do
    result = dockerfile(<<-MANIFEST)
    parent_image { 'centos:7':
      osfamily => 'el',
    }
    MANIFEST

    expect(result).to eq("FROM centos:7\n")
  end

  it "returns the correct string given parent_image and file resources" do
    result = dockerfile(<<-MANIFEST)
    parent_image { 'centos:7':
      osfamily => 'el',
    }

    package { 'test':
      ensure => present,
    }

    package { 'test2':
      ensure => present,
    }
    MANIFEST

    expect(result).to eq("FROM centos:7\nCMD yum install test\nCMD yum install test2\n")
  end

  it "returns the correct string when given no resources" do
    result = dockerfile("")
    expect(result).to eq("")
  end
end
