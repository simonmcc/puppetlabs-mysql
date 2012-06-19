# This has to be a separate type to enable collecting
Puppet::Type.newtype(:dynamic_variable) do
  @doc = "Manage a database system variables, dynamic/runtime only"

  newparam(:name, :namevar=>true) do
    desc "The name of the dynamic variable, e.g. max_connections"
    # "Variable Name" from http://dev.mysql.com/doc/refman//5.5/en/server-system-variables.html
 
    # limit to variables we understand - limiting here stops the self.instances from being useful
    # (unless we also filter/limit what's returned there?)
#    supported_variables = [ 'max_connections' ] 
#   validate do |value|
#      raise(ArgumentError, "Unsupported MySQL variable #{value}") unless supported_variables.include?(value)
#    end
  end

  newproperty(:value) do
    desc "The value of the dynamic variable"
  end

end

