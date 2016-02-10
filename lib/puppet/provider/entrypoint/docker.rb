require 'puppet/type'

Puppet::Type.type(:entrypoint).provide(:docker) do
  confine :feature => :docker

  def dockerfile_line(context)
    "ENTRYPOINT #{@resource[:command]}"
  end
end
