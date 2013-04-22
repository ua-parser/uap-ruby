require 'yaml'

module UserAgentParser
  
  class Parser
    attr_reader :patterns_path

    def initialize(options={})
      @patterns_path = options[:patterns_path] || UserAgentParser::DefaultPatternsPath
      @ua_patterns, @os_patterns, @device_patterns = load_patterns(patterns_path)
    end

    def parse(user_agent)
      os = parse_os(user_agent)
      device = parse_device(user_agent)
      parse_ua(user_agent, os, device)
    end

  private

    def load_patterns(path)
      yml = YAML.load_file(path)

      # Parse all the regexs
      yml.each_pair do |type, patterns|
        patterns.each do |pattern|
          pattern["regex"] = Regexp.new(pattern["regex"])
        end
      end

      [ yml["user_agent_parsers"], yml["os_parsers"], yml["device_parsers"] ]
    end

    def parse_ua(user_agent, os = nil, device = nil)
      pattern, match = first_pattern_match(@ua_patterns, user_agent)

      if match
        user_agent_from_pattern_match(pattern, match, os, device)
      else
        UserAgent.new(nil, nil, os, device)
      end
    end

    def parse_os(user_agent)
      pattern, match = first_pattern_match(@os_patterns, user_agent)

      if match
        os_from_pattern_match(pattern, match)
      else
        OperatingSystem.new
      end
    end

    def parse_device(user_agent)
      pattern, match = first_pattern_match(@device_patterns, user_agent)

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
      name, v1, v2, v3, v4 = match[1], match[2], match[3], match[4], match[5]

      if pattern["family_replacement"]
        name = pattern["family_replacement"].sub('$1', name || '')
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
        v4 = pattern["v4_replacement"].sub('$1', v4 || '')
      end

      version = version_from_segments(v1, v2, v3, v4)

      UserAgent.new(name, version, os, device)
    end

    def os_from_pattern_match(pattern, match)
      os, v1, v2, v3, v4 = match[1], match[2], match[3], match[4], match[5]

      if pattern["os_replacement"]
        os = pattern["os_replacement"].sub('$1', os || '')
      end

      if pattern["os_v1_replacement"]
        v1 = pattern["os_v1_replacement"].sub('$1', v1 || '')
      end

      if pattern["os_v2_replacement"]
        v2 = pattern["os_v2_replacement"].sub('$1', v2 || '')
      end

      if pattern["os_v3_replacement"]
        v3 = pattern["os_v3_replacement"].sub('$1', v3 || '')
      end

      if pattern["os_v4_replacement"]
        v4 = pattern["os_v4_replacement"].sub('$1', v4 || '')
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
