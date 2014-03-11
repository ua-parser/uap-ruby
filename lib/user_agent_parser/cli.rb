module UserAgentParser
  class Cli
    def initialize(user_agent, options = {})
      @user_agent = UserAgentParser.parse(user_agent)
      @options = options
    end

    def run!
      if @options[:name]
        @user_agent.name
      elsif @options[:version]
        @user_agent.version.to_s
      elsif @options[:major]
        @user_agent.version.major
      elsif @options[:minor]
        @user_agent.version.minor
      elsif @options[:os]
        @user_agent.os.to_s
      elsif format = @options[:format]
        format.gsub('%n', @user_agent.name).
          gsub('%v', @user_agent.version.to_s).
          gsub('%M', @user_agent.version.major.to_s).
          gsub('%m', @user_agent.version.minor.to_s).
          gsub('%o', @user_agent.os.to_s)
      else
        @user_agent.to_s
      end
    end
  end
end
