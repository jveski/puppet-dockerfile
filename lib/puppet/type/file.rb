require 'puppet/type'

Puppet::Type.newtype(:file) do
  newparam(:src)
  newparam(:dest, :namevar => true)

  validate do
    if self[:src] && self[:dest]
      if self[:src] =~ /^http.*/
        fail "Dockerfile: the File resource type requires well formed URLs, src => #{self[:src]}" unless URI.parse(self[:src])
      else
        fail "Dockerfile: the File resource type requires an absolute path for the 'src' parameter." unless self[:src] =~ /^\/.*/
        fail "Dockerfile: the File resource file was unable to source the file/dir: #{self[:src]}" unless File.exists?(self[:src])
      end
    else
      fail "Dockerfile: the File type requires that both the 'src' and 'dest' parameters be provided."
    end
  end
end
