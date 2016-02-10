require 'puppet/type'

Puppet::Type.type(:file).provide(:docker_el) do
  confine :feature => :docker
  has_features :versionable

  def build_script(context)
    version = @resource[:ensure]

    case version
    when :present
      script = "ADD #{@resource[:src]} #{@resource[:dest]}"
    when :absent
      # Do nothing since we can not remove lines from a Dockerfile we intend to push STDIN
    end

    # TODO: Honor other attributes. Source, install_options, etc.

    script
  end
end
