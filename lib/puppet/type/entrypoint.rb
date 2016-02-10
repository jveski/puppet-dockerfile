require 'puppet/type'

Puppet::Type.newtype(:entrypoint) do
  newparam(:command, :namevar => true)
end
