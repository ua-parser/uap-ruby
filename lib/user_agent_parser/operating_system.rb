# frozen_string_literal: true

module UserAgentParser
  class OperatingSystem
    DEFAULT_FAMILY = 'Other'

    attr_reader :family, :version

    alias name family

    def initialize(family = DEFAULT_FAMILY, version = nil)
      @family = family
      @version = version
    end

    def to_s
      string = family
      string += " #{version}" unless version.nil?
      string
    end

    def inspect
      "#<#{self.class} #{self}>"
    end

    def eql?(other)
      self.class.eql?(other.class) &&
        family == other.family &&
        version == other.version
    end

    alias == eql?

    def to_h
      {
        version: version.to_h,
        family: family
      }
    end
  end
end
