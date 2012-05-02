require 'yaml'

module UserAgentParser

  class Parser

    def parse user_agent
      ua = parse_ua(user_agent)
      ua.os = parse_os(user_agent)
      ua
    end
  
  private

    def all_patterns
      @all_patterns ||= YAML.load_file(UserAgentParser.patterns_path)
    end

    def patterns type
      @patterns ||= {}
      @patterns[type] ||= begin
        all_patterns[type].each do |p|
          p["regex"] = Regexp.new(p["regex"])
        end
      end
    end
  
    def parse_ua user_agent
      pattern, match = first_pattern_match(patterns("user_agent_parsers"), user_agent)
      if match
        user_agent_from_pattern_match(pattern, match)
      else
        UserAgent.new
      end
    end
  
    def parse_os user_agent
      pattern, match = first_pattern_match(patterns("os_parsers"), user_agent)
      if match
        os_from_pattern_match(pattern, match)
      else
        OperatingSystem.new
      end
    end

    def first_pattern_match patterns, value
      for p in patterns
        if m = p["regex"].match(value)
          return [p, m]
        end
      end
      nil
    end

    def user_agent_from_pattern_match pattern, match
      family, v1, v2, v3 = match[1], match[2], match[3], match[4]
      if pattern["family_replacement"]
        family = pattern["family_replacement"].sub('$1', family || '')
      end
      v1 = pattern["v1_replacement"].sub('$1', v1 || '') if pattern["v1_replacement"]
      v2 = pattern["v2_replacement"].sub('$1', v2 || '') if pattern["v2_replacement"]
      v3 = pattern["v3_replacement"].sub('$1', v3 || '') if pattern["v3_replacement"] 
      ua = UserAgent.new(family)
      ua.version = version_from_segments(v1, v2, v3)
      ua
    end
  
    def os_from_pattern_match pattern, match
      os, v1, v2, v3, v4 = match[1], match[2], match[3], match[4], match[5]
      os = pattern["os_replacement"].sub('$1', os || '') if pattern["os_replacement"]
      v1 = pattern["v1_replacement"].sub('$1', v1 || '') if pattern["v1_replacement"]
      v2 = pattern["v2_replacement"].sub('$1', v2 || '') if pattern["v2_replacement"]
      v3 = pattern["v3_replacement"].sub('$1', v3 || '') if pattern["v3_replacement"]
      v4 = pattern["v3_replacement"].sub('$1', v3 || '') if pattern["v4_replacement"]
      os = OperatingSystem.new(os)
      os.version = version_from_segments(v1, v2, v3, v4)
      os
    end
  
    def version_from_segments(*segments)
      version_string = segments.compact.join(".")
      version_string.empty? ? nil : Version.new(version_string)
    end
  
  end

end
