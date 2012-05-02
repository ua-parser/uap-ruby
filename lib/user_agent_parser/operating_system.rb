module UserAgentParser

  class OperatingSystem
  
    attr_accessor :name, :version
  
    def initialize(name="Other", version=nil)
      self.name = name
      self.version = version
    end
  
    def to_s
      s = name
      s += " #{version}" if version
      s
    end
  
    def inspect
      "#<#{self.class} #{to_s}>"
    end
  
    def ==(other)
      name == other.name && version == other.version
    end
  
  end

end