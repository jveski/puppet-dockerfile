require 'puppet/type'

Puppet::Type.type(:parent_image).provide(:docker) do
  confine :feature => :docker

  def dockerfile_line(context)
    "FROM #{@resource[:name]}"
  end
end
