module UserAgentParser
  class Device
    attr_reader :name

    def initialize(name = nil)
      @name = name || 'Other'
    end

    def to_s
      name
    end

    def inspect
      "#<#{self.class} #{to_s}>"
    end

    def eql?(other)
      self.class.eql?(other.class) && name == other.name
    end

    alias_method :==, :eql?
  end
end
