module UserAgentParser
  class UserAgent
    attr_reader :name, :version, :os, :device

    # For backwards compatibility with older versions of this gem.
    alias_method :family, :name

    def initialize(name = nil, version = nil, os = nil, device = nil)
      @name = name || 'Other'
      @version = version
      @os = os
      @device = device
    end

    def to_s
      string = name
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
      name == other.name &&
        version == other.version &&
        os == other.os
    end

    alias_method :==, :eql?
  end
end
