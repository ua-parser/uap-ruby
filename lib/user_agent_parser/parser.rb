# frozen_string_literal: true

require 'yaml'

module UserAgentParser
  class Parser
    FAMILY_REPLACEMENT_KEYS = %w[
      family_replacement
      v1_replacement
      v2_replacement
      v3_replacement
      v4_replacement
    ].freeze

    OS_REPLACEMENT_KEYS = %w[
      os_replacement
      os_v1_replacement
      os_v2_replacement
      os_v3_replacement
      os_v4_replacement
    ].freeze

    private_constant :FAMILY_REPLACEMENT_KEYS, :OS_REPLACEMENT_KEYS

    attr_reader :patterns_path

    def initialize(options = {})
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
      yml.each_pair do |_type, patterns|
        patterns.each do |pattern|
          pattern[:regex] = Regexp.new(pattern['regex'], pattern['regex_flag'] == 'i')
        end
      end

      [yml['user_agent_parsers'], yml['os_parsers'], yml['device_parsers']]
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

    if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('2.4.0')
      def first_pattern_match(patterns, value)
        patterns.each do |pattern|
          if pattern[:regex].match?(value)
            return [pattern, pattern[:regex].match(value)]
          end
        end
        nil
      end
    else
      def first_pattern_match(patterns, value)
        patterns.each do |pattern|
          if (match = pattern[:regex].match(value))
            return [pattern, match]
          end
        end
        nil
      end
    end

    def user_agent_from_pattern_match(pattern, match, os = nil, device = nil)
      family, *versions = from_pattern_match(FAMILY_REPLACEMENT_KEYS, pattern, match)

      UserAgent.new(family, version_from_segments(*versions), os, device)
    end

    def os_from_pattern_match(pattern, match)
      os, *versions = from_pattern_match(OS_REPLACEMENT_KEYS, pattern, match)

      OperatingSystem.new(os, version_from_segments(*versions))
    end

    def device_from_pattern_match(pattern, match)
      match = match.to_a.map(&:to_s)
      family = model = match[1]
      brand = nil

      if pattern['device_replacement']
        family = pattern['device_replacement']
        match.each_with_index { |m, i| family = family.sub("$#{i}", m) }
      end
      if pattern['model_replacement']
        model = pattern['model_replacement']
        match.each_with_index { |m, i| model = model.sub("$#{i}", m) }
      end
      if pattern['brand_replacement']
        brand = pattern['brand_replacement']
        match.each_with_index { |m, i| brand = brand.sub("$#{i}", m) }
        brand.strip!
      end

      model&.strip!

      Device.new(family.strip, model, brand)
    end

    # Maps replacement keys to their values
    def from_pattern_match(keys, pattern, match)
      keys.each_with_index.map do |key, idx|
        # Check if there is any replacement specified
        if pattern[key]
          interpolate(pattern[key], match)
        else
          # No replacement defined, just return correct match group
          match[idx + 1]
        end
      end
    end

    # Interpolates a string with data from matches if specified
    def interpolate(replacement, match)
      group_idx = replacement.index('$')
      return replacement if group_idx.nil?

      group_nbr = replacement[group_idx + 1]
      replacement.sub("$#{group_nbr}", match[group_nbr.to_i])
    end

    def version_from_segments(*segments)
      return if segments.all?(&:nil?)

      Version.new(*segments)
    end
  end
end
