module UserAgentParser
  class UserAgent
    attr_reader :family, :version, :os

    def initialize(family = nil, version = nil, os = nil)
      @family = family || 'Other'
      @version = version
      @os = os
    end

    def to_s
      string = family
      string += " #{version}" if version
      string
    end

    def inspect
      string = to_s
      string += " (#{os})" if os
      "#<#{self.class} #{string}>"
    end

    def ==(other)
      family == other.family &&
        version == other.version &&
        os == other.os
    end

    alias_method :eql?, :==
  end
end
