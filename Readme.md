# UserAgentParser [![Build Status](https://secure.travis-ci.org/toolmantim/user_agent_parser.png?branch=master)](http://travis-ci.org/toolmantim/user_agent_parser)

UserAgentParser is a simple, comprehensive Ruby gem for parsing user agent strings. It uses [BrowserScope](http://www.browserscope.org/)'s [parsing patterns](https://github.com/tobie/ua-parser).

## Requirements

* Ruby >= 1.8.7

## Installation

```bash
$ gem install user_agent_parser
```

## Example usage

```ruby
require 'user_agent_parser'
=> true
user_agent = UserAgentParser.parse 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.0;)'
=> #<UserAgentParser::UserAgent IE 9.0 (Windows Vista)>
user_agent.to_s
=> "IE 9.0"
user_agent.name
=> "IE"
user_agent.version.to_s
=> "9.0"
user_agent.version.major
=> "9"
user_agent.version.minor
=> "0"
operating_system = user_agent.os
=> #<UserAgentParser::OperatingSystem Windows Vista>
operating_system.to_s
=> "Windows Vista"

# The parser database will be loaded and parsed on every call to
# UserAgentParser.parse. To avoid this, instantiate your own Parser instance.
parser = UserAgentParser::Parser.new
parser.parse 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.0;)'
=> #<UserAgentParser::UserAgent IE 9.0 (Windows Vista)>
parser.parse 'Opera/9.80 (Windows NT 5.1; U; ru) Presto/2.5.24 Version/10.53'
=> #<UserAgentParser::UserAgent Opera 10.53 (Windows XP)>
```

In a larger application, you could store a parser in a global to avoid repeat pattern loading:

```ruby
module MyApplication

  # Instantiate the parser on load as it's quite expensive
  USER_AGENT_PARSER = UserAgentParser::Parser.new

  def self.user_agent_parser
    USER_AGENT_PARSER
  end

end
```

## The pattern database

The [ua-parser database](https://github.com/tobie/ua-parser/blob/master/regexes.yaml) is included via a [git submodule](http://help.github.com/submodules/). To update the database the submodule needs to be updated and the gem re-released (pull requests for this are very welcome!).

You can also specify the path to your own, updated and/or customised `regexes.yaml` file as a second argument to `UserAgentParser.parse`:

```ruby
UserAgentParser.parse(ua_string, patterns_path: '/some/path/to/regexes.yaml')
```

or when instantiating a `UserAgentParser::Parser`:

```ruby
UserAgentParser::Parser.new(patterns_path: '/some/path/to/regexes.yaml').parse(ua_string)
```

## Contributing

1. Fork
2. Hack
3. `rake test`
4. Send a pull request

All accepted pull requests will earn you commit and release rights.

## Releasing a new version

1. Update the version in `user_agent_parser.gemspec`
2. `git commit user_agent_parser.gemspec` with the following message format:

        Version x.x.x

        Changelog:
        * Some new feature
        * Some new bug fix
3. `rake release`

## License

MIT
