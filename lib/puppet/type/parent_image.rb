require 'puppet/type'

Puppet::Type.newtype(:parent_image) do
  newparam(:name) do
  end

  newparam(:osfamily) do
    validate do |value|
      raise Puppet::Error, "'#{value}' is not a supported osfamily for the dockerfile function. It currently only supports 'el'" unless value == 'el'
    end
  end
end
