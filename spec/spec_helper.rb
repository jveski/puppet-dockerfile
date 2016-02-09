require 'puppetlabs_spec_helper/module_spec_helper'
require 'puppet/functions/dockerfile'
require 'puppet/parser/compiler'
require 'puppet/node'
require 'fileutils'

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
  File.expand_path("../../", __FILE__)
end

def compile(pp)
  Puppet[:code] = pp

  test_modulepath = "#{Puppet[:environmentpath]}/#{Puppet[:environment]}/modules"
  unless File.symlink? "#{test_modulepath}/dockerfile"
    FileUtils.mkdir_p(test_modulepath)
    FileUtils.ln_s(path, "#{test_modulepath}/dockerfile")
  end

  node = Puppet::Node.new('testnode')
  compiler = Puppet::Parser::Compiler.new(node)
  scope = Puppet::Parser::Scope.new(compiler)

  catalog = scope.compiler.compile.filter { |r| r.virtual? }
  catalog.resource('File[/test]').to_hash[:content]
end
