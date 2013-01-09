require 'yaml'

module UserAgentParser
  class Parser
    attr_reader :patterns_path

    def initialize(patterns_path = UserAgentParser.patterns_path)
      @patterns_path = patterns_path
      @patterns = {}
    end

    def parse(user_agent)
      os = parse_os(user_agent)
      device = parse_device(user_agent)
      parse_ua(user_agent, os, device)
    end

  private

    def all_patterns
      @all_patterns ||= YAML.load_file(@patterns_path)
    end

    def patterns(type)
      @patterns[type] ||= begin
        all_patterns[type].each do |pattern|
          pattern["regex"] = Regexp.new(pattern["regex"])
        end
      end
    end

    def parse_ua(user_agent, os = nil, device = nil)
      pattern, match = first_pattern_match(patterns("user_agent_parsers"), user_agent)

      if match
        user_agent_from_pattern_match(pattern, match, os, device)
      else
        UserAgent.new(nil, nil, os, device)
      end
    end

    def parse_os(user_agent)
      pattern, match = first_pattern_match(patterns("os_parsers"), user_agent)

      if match
        os_from_pattern_match(pattern, match)
      else
        OperatingSystem.new
      end
    end

    def parse_device(user_agent)
      pattern, match = first_pattern_match(patterns("device_parsers"), user_agent)

      if match
        device_from_pattern_match(pattern, match)
      else
        Device.new
      end
    end

    def first_pattern_match(patterns, value)
      patterns.each do |pattern|
        if match = pattern["regex"].match(value)
          return [pattern, match]
        end
      end

      nil
    end

    def user_agent_from_pattern_match(pattern, match, os = nil, device = nil)
      family, v1, v2, v3 = match[1], match[2], match[3], match[4]

      if pattern["family_replacement"]
        family = pattern["family_replacement"].sub('$1', family || '')
      end

      if pattern["v1_replacement"]
        v1 = pattern["v1_replacement"].sub('$1', v1 || '')
      end

      if pattern["v2_replacement"]
        v2 = pattern["v2_replacement"].sub('$1', v2 || '')
      end

      if pattern["v3_replacement"]
        v3 = pattern["v3_replacement"].sub('$1', v3 || '')
      end

      version = version_from_segments(v1, v2, v3)

      UserAgent.new(family, version, os, device)
    end

    def os_from_pattern_match(pattern, match)
      os, v1, v2, v3, v4 = match[1], match[2], match[3], match[4], match[5]

      if pattern["os_replacement"]
        os = pattern["os_replacement"].sub('$1', os || '')
      end

      if pattern["v1_replacement"]
        v1 = pattern["v1_replacement"].sub('$1', v1 || '')
      end

      if pattern["v2_replacement"]
        v2 = pattern["v2_replacement"].sub('$1', v2 || '')
      end

      if pattern["v3_replacement"]
        v3 = pattern["v3_replacement"].sub('$1', v3 || '')
      end

      if pattern["v4_replacement"]
        v4 = pattern["v3_replacement"].sub('$1', v3 || '')
      end

      version = version_from_segments(v1, v2, v3, v4)

      OperatingSystem.new(os, version)
    end

    def device_from_pattern_match(pattern, match)
      device = match[1]

      if pattern["device_replacement"]
        device = pattern["device_replacement"].sub('$1', device || '')
      end

      Device.new(device)
    end

    def version_from_segments(*segments)
      version_string = segments.compact.join(".")
      version_string.empty? ? nil : Version.new(version_string)
    end
  end
end
