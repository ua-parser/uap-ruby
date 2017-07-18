# frozen_string_literal: true

module UserAgentParser
  class Device
    attr_reader :family

    alias name family

    def initialize(family = nil)
      @family = family || 'Other'
    end

    def to_s
      family
    end

    def inspect
      "#<#{self.class} #{to_s}>"
    end

    def eql?(other)
      self.class.eql?(other.class) && family == other.family
    end

    alias == eql?
  end
end
