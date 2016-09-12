module UserAgentParser
  class UserAgent
    attr_reader :family, :version, :os, :device, :client, :custom_attributes

    alias_method :name, :family

    def initialize(family = nil, version = nil, os = nil, device = nil, client = nil, custom_attributes = nil)
      @family = family || 'Other'
      @version = version
      @os = os
      @device = device
      @client = client
      @custom_attributes = custom_attributes
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
      string += " (#{custom_attributes.to_s})" if custom_attributes
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
