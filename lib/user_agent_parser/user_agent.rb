# frozen_string_literal: true

module UserAgentParser
  class UserAgent
    DEFAULT_FAMILY = 'Other'

    attr_reader :family, :version, :os, :device

    alias name family

    def initialize(family = nil, version = nil, os = nil, device = nil)
      @family = family || DEFAULT_FAMILY
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

    alias == eql?

    def to_h
      {
        device: device.to_h,
        family: family,
        os: os.to_h,
        version: version.to_h
      }
    end
  end
end
