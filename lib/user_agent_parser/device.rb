module UserAgentParser
  class Device
    attr_reader :family, :model, :brand

    alias_method :name, :family

    def initialize(family = nil, model = nil, brand = nil)
      @family = family || 'Other'
      @model = model || @family
      @brand = brand
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

    alias_method :==, :eql?
  end
end
