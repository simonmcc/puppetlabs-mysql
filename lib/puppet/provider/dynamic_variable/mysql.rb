Puppet::Type.type(:dynamic_variable).provide(:mysql) do

  desc "Manages MySQL dynamic system variables."

  defaultfor :kernel => 'Linux'

  optional_commands :mysql      => 'mysql'

  def self.instances
    mysql('-NBe', "SHOW VARIABLES").split("\n").collect { |kv| new(:name => kv.split("\t")[0]) }
  end

#  you can't create system variables, they can only be set
#  def create
#  end

  def value
    mysql('-NBe', "show variables like '#{resource[:name]}'").split("\t")[1].chomp
  end

  def value=(v)
    mysql('-NBe', "set global #{resource[:name]} = #{v}")
  end

  def exists?
    begin
      mysql('-NBe', "SHOW VARIABLES").match(/^#{@resource[:name]}\t/)
    rescue => e
      debug(e.message)
      return nil
    end
  end

end

