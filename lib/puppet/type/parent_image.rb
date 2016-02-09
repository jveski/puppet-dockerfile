require 'puppet/type'

Puppet::Type.newtype(:parent_image) do
  newparam(:name) do
  end

  newparam(:osfamily) do
    defaultto ''

    munge do |value|
      name = @resource[:name]

      return value if value != ''
      return "el" if name =~ /^centos/
      return "debian" if name =~ /^ubuntu/
    end
  end
end
