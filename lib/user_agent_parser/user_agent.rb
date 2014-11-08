module UserAgentParser
  class UserAgent
    attr_reader :family, :version, :os, :device

    alias_method :name, :family

    def initialize(family = nil, version = nil, os = nil, device = nil)
      @family = family || 'Other'
      @version = version
      @os = os
      @device = device
    end

    def to_s
      string = family
      string += " #{version}" if version
      string
    end

    def inspect
      string = to_s
      string += " (#{os})" if os
      string += " (#{device})" if device
      "#<#{self.class} #{string}>"
    end

    def eql?(other)
      self.class.eql?(other.class) &&
      family == other.family &&
        version == other.version &&
        os == other.os
    end

    alias_method :==, :eql?
  end
end
