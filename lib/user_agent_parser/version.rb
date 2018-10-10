# frozen_string_literal: true

module UserAgentParser
  class Version
    # Private: Regex used to split string version string into major, minor,
    # patch, and patch_minor.
    SEGMENTS_REGEX = /\d+\-\d+|\d+[a-zA-Z]+$|\d+|[A-Za-z][0-9A-Za-z-]*$/

    attr_reader :version
    alias to_s version

    def initialize(*args)
      # If only one string argument is given, assume a complete version string
      # and attempt to parse it
      if args.length == 1 && args.first.is_a?(String)
        @version = args.first.to_s.strip
      else
        @segments = args.compact.map(&:to_s).map(&:strip)
        @version = segments.join('.')
      end
    end

    def major
      segments[0]
    end

    def minor
      segments[1]
    end

    def patch
      segments[2]
    end

    def patch_minor
      segments[3]
    end

    def inspect
      "#<#{self.class} #{self}>"
    end

    def eql?(other)
      self.class.eql?(other.class) &&
        version == other.version
    end

    alias == eql?

    # Private
    def segments
      @segments ||= version.scan(SEGMENTS_REGEX)
    end

    def to_h
      {
        version: version,
        major: major,
        minor: minor,
        patch: patch,
        patch_minor: patch_minor
      }
    end
  end
end
