module UserAgentParser
  class OperatingSystem
    attr_reader :name, :version

    def initialize(name = 'Other', version = nil)
      @name = name
      @version = version
    end

    def to_s
      string = name
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
        name == other.name &&
        version == other.version
    end

    alias_method :==, :eql?
  end
end
