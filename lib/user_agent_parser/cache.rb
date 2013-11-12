module UserAgentParser
  class Cache
    def initialize
      @registry = {}
    end

    def fetch(options)
      @registry.fetch(options.hash) do
        add(options)
      end
    end

    def add(options)
      @registry[options.hash] = Parser.new(options)
    end
  end
end
