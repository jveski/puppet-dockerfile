Puppet::Type.type(:file).provide(:docker) do
  confine :feature => :docker

  def dockerfile_line(context)
    raise Puppet::Error, "The File type docker provider requires that both the 'source' and 'path' parameters be provided." unless @resource[:path] && @resource[:source]

    "ADD #{@resource[:source][0].split(':')[1]} #{@resource[:path]}"
  end
end
