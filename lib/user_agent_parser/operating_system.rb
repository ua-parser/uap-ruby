module UserAgentParser
  class OperatingSystem
    attr_reader :family, :version

    alias_method :name, :family

    def initialize(family = 'Other', version = nil)
      @family = family
      @version = version
    end

    def to_s
      string = family
      unless version.nil?
        string += " #{version}"
      end
      string
    end

    def inspect
      "#<#{self.class} #{to_s}>"
    end

    def eql?(other)
      self.class.eql?(other.class) &&
        family == other.family &&
        version == other.version
    end

    alias_method :==, :eql?
  end
end
