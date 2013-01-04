module UserAgentParser

  class Version

    attr_accessor :version
    alias :to_s :version

    def initialize(version)
      self.version = version.to_s.strip
    end

    def segments
      version.scan(/\d+\-\d+|\d+[a-zA-Z]+$|\d+|[A-Za-z][0-9A-Za-z-]*$/).map do |s|
        s
      end
    end

    def [](segment)
      segments[segment]
    end

    def major; self[0] end
    def minor; self[1] end
    def patch; self[2] end
    def patch_minor; self[3] end

    def inspect
      "#<#{self.class} #{to_s}>"
    end

    def ==(other)
      version == other.version
    end

  end

end
