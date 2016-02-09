require 'puppetlabs_spec_helper/module_spec_helper'
require 'puppet/functions/dockerfile'
require 'puppet/parser/compiler'
require 'puppet/node'

class StubContext
  attr_accessor :parent_image, :osfamily, :visited, :scripts

  def self.for(osfamily)
    instance = new
    instance.osfamily = osfamily
    instance
  end
end

def dockerfile(pp)
  pp = <<-MANIFEST
  $dockerfile = dockerfile() || {
  #{pp}
  }

  file { '/test':
    ensure  => present,
    content => $dockerfile,
  }
  MANIFEST

  compile(pp)
end

def path
  File.expand_path("../../../", __FILE__)
end

def compile(pp)
  Puppet[:code] = pp

  env = Puppet::Node::Environment.create('testing', [path])
  node = Puppet::Node.new('testnode', :environment => env)
  compiler = Puppet::Parser::Compiler.new(node)
  scope = Puppet::Parser::Scope.new(compiler)

  catalog = scope.compiler.compile.filter { |r| r.virtual? }
  catalog.resource('File[/test]').to_hash[:content]
end
