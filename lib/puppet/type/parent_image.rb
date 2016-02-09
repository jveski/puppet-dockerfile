require 'puppet/type'

Puppet::Type.newtype(:parent_image) do
  newparam(:name) do
  end

  newparam(:osfamily) do
  end
end
