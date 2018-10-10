# frozen_string_literal: true

module UserAgentParser
  class Cli
    def initialize(user_agent, options = {})
      @user_agent = user_agent
      @options = options
    end

    def run!
      if @options[:family]
        @user_agent.family
      elsif @options[:name]
        @user_agent.name
      elsif @options[:version]
        with_version(&:to_s)
      elsif @options[:major]
        major
      elsif @options[:minor]
        minor
      elsif @options[:os]
        @user_agent.os.to_s
      elsif (format = @options[:format])
        format
          .gsub('%f', @user_agent.family)
          .gsub('%n', @user_agent.name)
          .gsub('%v', version.to_s)
          .gsub('%M', major.to_s)
          .gsub('%m', minor.to_s)
          .gsub('%o', @user_agent.os.to_s)
      else
        @user_agent.to_s
      end
    end

    private

    def major
      with_version(&:major)
    end

    def minor
      with_version(&:minor)
    end

    def version
      @version ||= @user_agent.version
    end

    def with_version
      yield(version) if version
    end
  end
end
