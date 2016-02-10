require 'spec_helper'

describe "the dockerfile function" do
  it "falls back to the generic provider if the resource doesn't have a platform specific one" do
    Puppet::Type.newtype(:foo_type) do
      newparam(:name) do
      end
    end

    Puppet::Type.type(:foo_type).provide(:docker) do
      def dockerfile_line(context)
        "test line"
      end
    end

    pp = <<-MANIFEST
    parent_image { 'foo':
      osfamily => 'bar',
    }

    foo_type { 'baz': }
    MANIFEST

    result = dockerfile(pp)
    expect(result).to include("test line")
  end

  it "raises an error if the provider doesn't have a dockerfile_line method" do
    Puppet::Type.newtype(:bar_type) do
      newparam(:name) do
      end
    end

    Puppet::Type.type(:bar_type).provide(:docker_bar) do
    end

    pp = <<-MANIFEST
    parent_image { 'foo':
      osfamily => 'bar',
    }

    bar_type { 'baz': }
    MANIFEST

    expect{ dockerfile(pp) }.to raise_error(/'docker_bar' provider doesn't implement a dockerfile_line/)
  end

  it "raises an error if the provider's dockerfile_line method returns an array" do
    Puppet::Type.newtype(:baz_type) do
      newparam(:name) do
      end
    end

    Puppet::Type.type(:baz_type).provide(:docker_bar) do
      def dockerfile_line(context)
        []
      end
    end

    pp = <<-MANIFEST
    parent_image { 'foo':
      osfamily => 'bar',
    }

    baz_type { 'baz': }
    MANIFEST

    expect{ dockerfile(pp) }.to raise_error(/didn't return a string/)
  end

  it "raises an error when given a single package resource" do
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

    expect{ dockerfile(pp) }.to raise_error(/lacks a Dockerfile provider/)
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

    expect(result).to eq("FROM foo")
  end

  it "returns the correct string given a parent_image resource" do
    result = dockerfile(<<-MANIFEST)
    parent_image { 'centos:7':
      osfamily => 'el',
    }
    MANIFEST

    expect(result).to eq("FROM centos:7")
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

    expect(result).to eq("FROM centos:7\nRUN yum install test -y\nRUN yum install test2 -y")
  end

  it "returns the correct string when given no resources" do
    result = dockerfile("")
    expect(result).to eq("")
  end
end
