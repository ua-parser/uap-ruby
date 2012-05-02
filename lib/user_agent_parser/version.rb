module UserAgentParser
  
  class Version

    attr_accessor :version
    alias :to_s :version

    def initialize(version)
      self.version = version.to_s.strip
    end

    def segments
      version.scan(/\d+\-\d+|\d+[a-zA-Z]+$|\d+|[A-Za-z][0-9A-Za-z-]*$/).map do |s|
        /^\d+$/ =~ s ? s.to_i : s
      end
    end

    def [](segment)
      segments[segment]
    end
  
    def inspect
      "#<#{self.class} #{to_s}>"
    end
    
    def ==(other)
      version == other.version
    end

  end

end