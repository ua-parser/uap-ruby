# frozen_string_literal: true

module UserAgentParser
  class Device
    DEFAULT_FAMILY = 'Other'

    attr_reader :family, :model, :brand

    alias name family

    def initialize(family = nil, model = nil, brand = nil)
      @family = family || DEFAULT_FAMILY
      @model = model || @family
      @brand = brand
    end

    def to_s
      family
    end

    def inspect
      "#<#{self.class} #{self}>"
    end

    def eql?(other)
      self.class.eql?(other.class) && family == other.family
    end

    alias == eql?

    def to_h
      {
        family: family,
        model: model,
        brand: brand
      }
    end
  end
end
