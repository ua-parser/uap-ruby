require 'yaml'
require 'json'

module UserAgentParser

  class Parser
    attr_reader :patterns_path

    def initialize(options={})
      @patterns_path = options[:patterns_path] || UserAgentParser::DefaultPatternsPath
      @ua_patterns, @os_patterns, @device_patterns, @client_patterns, @custom_patterns = load_patterns(
          patterns_path,
          options[:custom_patterns])
    end

    def parse(user_agent)
      os = parse_os(user_agent)
      device = parse_device(user_agent)
      client = parse_client(user_agent, os.family)
      custom_matches = parse_custom(user_agent)
      parse_ua(user_agent, os, device, client, custom_matches)
    end

    private

    def load_patterns(path, custom_patterns = nil)
      yml = YAML.load_file(path)

      # Parse all the regexs
      yml.each_pair do |type, patterns|
        patterns.each do |pattern|
          pattern["regex"] = Regexp.new(pattern["regex"], pattern["regex_flag"] == 'i')
        end
      end

      yml["custom_patterns"] = []
      if custom_patterns
        custom_patterns.each do |pattern|
          pattern["regex"] = Regexp.new(pattern["regex"], pattern["regex_flag"] == 'i')
          case pattern["class"]
            when "user_agent_parsers"
              pattern.keys.each do |k|
                unless k.include? 'regex'
                  pattern[k.sub(/extra1/, 'family_replacement')] = pattern[k]
                  pattern[k.sub(/extra2/, 'v1_replacement')] = pattern[k]
                  pattern[k.sub(/extra3/, 'v2_replacement')] = pattern[k]
                  pattern.delete(k)
                end
              end
              if pattern["top"]
                yml["user_agent_parsers"].unshift pattern
              else
                yml["user_agent_parsers"] << pattern
              end
            when "os_parsers"
              pattern.keys.each do |k|
                unless k.include? 'regex'
                  pattern[k.sub(/extra1/, 'os_replacement')] = pattern[k]
                  pattern[k.sub(/extra2/, 'os_v1_replacement')] = pattern[k]
                  pattern[k.sub(/extra3/, 'os_v2_replacement')] = pattern[k]
                  pattern.delete(k)
                end
              end
              if pattern["top"]
                yml["os_parsers"].unshift pattern
              else
                yml["os_parsers"] << pattern
              end
            when "device_parsers"
              pattern.keys.each do |k|
                unless k.include? 'regex'
                  pattern[k.sub(/extra1/, 'device_replacement')] = pattern[k]
                  pattern[k.sub(/extra2/, 'brand_replacement')] = pattern[k]
                  pattern[k.sub(/extra3/, 'model_replacement')] = pattern[k]
                  pattern.delete(k)
                end
              end
              if pattern["top"]
                yml["device_parsers"].unshift pattern
              else
                yml["device_parsers"] << pattern
              end
            when "client_parsers"
              pattern.keys.each do |k|
                unless k.include?('regex') || k.include?('client')
                  pattern[k.sub(/extra1/, 'client_replacement')] = pattern[k]
                  pattern[k.sub(/extra2/, 'client_v1_replacement')] = pattern[k]
                  pattern[k.sub(/extra3/, 'client_v2_replacement')] = pattern[k]
                  pattern.delete(k)
                end
              end
              yml["client_parsers"] ||= []
              if pattern["top"]
                yml["client_parsers"].unshift pattern
              else
                yml["client_parsers"] << pattern
              end
            else
              yml["custom_patterns"] << {"regex" => Regexp.new(pattern["regex"], pattern["regex_flag"] == 'i'), "name" => pattern["name"]}
          end
        end
      end

      [yml["user_agent_parsers"], yml["os_parsers"], yml["device_parsers"], yml["client_parsers"], yml["custom_patterns"]]
    end

    def parse_ua(user_agent, os = nil, device = nil, client = nil, custom_matches = nil)
      pattern, match = first_pattern_match(@ua_patterns, user_agent)
      if match
        user_agent_from_pattern_match(pattern, match, os, device, client, custom_matches)
      else
        UserAgent.new(nil, nil, os, device, client, custom_matches)
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

    def parse_client(user_agent, os_family)
      pattern, match = first_pattern_match(@client_patterns, user_agent)
      platform = platform_from_family(os_family)
      client_from_pattern_match(pattern, match, platform)
    end

    def parse_custom(user_agent)
      result = {}
      all_patterns_match(@custom_patterns, user_agent).each do |match|
        result[match[0]["name"]] = {"regex" => match[0]["regex"], "match" => match[1].to_a}
      end
      result.to_json
    end

    def first_pattern_match(patterns, value)
      patterns.each do |pattern|
        if match = pattern["regex"].match(value)
          return [pattern, match]
        end
      end
      nil
    end

    def all_patterns_match(patterns, value)
      matches = []
      patterns.each do |pattern|
        if match = pattern["regex"].match(value)
          matches << [pattern, match]
        end
      end
      matches
    end

    def user_agent_from_pattern_match(pattern, match, os = nil, device = nil, client = nil, custom_attributes = nil)
      family, v1, v2, v3, v4 = match[1], match[2], match[3], match[4], match[5]

      if pattern["family_replacement"]
        family = pattern["family_replacement"].sub('$1', family || '')
      end

      if pattern["v1_replacement"]
        v1 = pattern["v1_replacement"].sub('$2', v1 || '')
      end

      if pattern["v2_replacement"]
        v2 = pattern["v2_replacement"].sub('$3', v2 || '')
      end

      if pattern["v3_replacement"]
        v3 = pattern["v3_replacement"].sub('$4', v3 || '')
      end

      if pattern["v4_replacement"]
        v4 = pattern["v4_replacement"].sub('$5', v4 || '')
      end

      version = version_from_segments(v1, v2, v3, v4)
      UserAgent.new(family, version, os, device, client, custom_attributes)
    end

    def os_from_pattern_match(pattern, match)
      os, v1, v2, v3, v4 = match[1], match[2], match[3], match[4], match[5]

      if pattern["os_replacement"]
        os = pattern["os_replacement"].sub('$1', os || '')
      end

      if pattern["os_v1_replacement"]
        v1 = pattern["os_v1_replacement"].sub('$2', v1 || '')
      end

      if pattern["os_v2_replacement"]
        v2 = pattern["os_v2_replacement"].sub('$3', v2 || '')
      end

      if pattern["os_v3_replacement"]
        v3 = pattern["os_v3_replacement"].sub('$4', v3 || '')
      end

      if pattern["os_v4_replacement"]
        v4 = pattern["os_v4_replacement"].sub('$5', v4 || '')
      end

      version = version_from_segments(v1, v2, v3, v4)

      OperatingSystem.new(os, version)
    end

    def client_from_pattern_match(pattern, match, platform)
      if match
        v1, v2 = match[1], match[2]
        if pattern["client_replacement"]
          type = pattern["client_replacement"]
        end
        if pattern["client_v1_replacement"]
          v1 = pattern["client_v1_replacement"].sub('$1', v1 || '')
        end
        if pattern["client_v2_replacement"]
          v2 = pattern["client_v2_replacement"].sub('$2', v2 || '')
        end
      elsif (platform != 'unknown')
        type = 'web'
      end

      Client.new(platform, type, v1, v2)
    end

    def device_from_pattern_match(pattern, match)
      match = match.to_a.map(&:to_s)
      family = match[1]

      if pattern["device_replacement"]
        family = pattern["device_replacement"]
        match.each_with_index { |m, i| family = family.sub("$#{i}", m) }
      end

      Device.new(family.strip)
    end

    def version_from_segments(*segments)
      segments = segments.compact
      segments.empty? ? nil : Version.new(*segments)
    end

    def platform_from_family(os)
      return 'unknown' unless os
      case os.to_s.downcase
        when /android/
          return 'android'
        when /ios/
          return 'ios'
        when /windows.*phone/
          return 'windows_phone'
        when /blackberry/, /nokia/, /symbian/, /firefox os/
          return 'other_mobile'
        when /gentoo/, /solaris/, /debian/, /chrome os/, /mac os/, /windows/, /linux/
          return 'desktop'
        else
          return 'unknown'
      end
    end
  end
end
