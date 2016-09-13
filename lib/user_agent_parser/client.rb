module UserAgentParser
  class Client
    attr_reader :platform, :type, :major_version, :version

    def initialize(platform, type, major_version = nil, version = nil)
      platform ||= 'unknown'
      type ||= 'unknown'
      @platform = platform
      @type = type
      @major_version = major_version
      @version = version
    end

    def to_s
      string = "#{@platform} #{@type}"
      if major_version
        string += " #{major_version}"
      end
      if version
        string += " #{version}"
      end
      string
    end

    def inspect
      "#<#{self.class} #{to_s}>"
    end

    def eql?(other)
      self.class.eql?(other.class) &&
          platform == other.platform &&
          type == other.type &&
          major_version == other.major_version &&
          version == other.version
    end

    alias_method :==, :eql?
  end
end
