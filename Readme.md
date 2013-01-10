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

# You can also get an instance of the parser and re-use it. The main reason you
# would want to do this is performance. Each time a new parser instance is
# created, all the patterns have to be read from disk and parsed by YAML.
# Storing an instance of the parser means that will only happen once per
# application instance boot.
parser = UserAgentParser.new
parser.parse('...')

# And you can give each parser a different pattern file:
parser = UserAgentParser.new('some/new/path/to/regexes.yml')
parser.parse('...')
```

## The pattern database

The [ua-parser database](https://github.com/tobie/ua-parser/blob/master/regexes.yaml) is included via a [git submodule](http://help.github.com/submodules/). To update the database the submodule needs to be updated and the gem re-released (pull requests for this are very welcome!).

You can also specify the path to your own, updated and/or customised `regexes.yaml` file:

```ruby
UserAgentParser.patterns_path = '/some/path/to/regexes.yaml'
```

## Comprehensive you say?

```bash
$ rake test
... [snip] ...

Finished tests in 6.877135s, 1874.9087 tests/s, 4945.9550 assertions/s.

12894 tests, 34014 assertions, 0 failures, 0 errors, 0 skips
```

## Limitations

There's no support for providing overrides from Javascript user agent detection like there is with original BrowserScope library. The Javascript overrides were only necessary for detecting IE 9 Platform Preview and older versions of [Chrome Frame](https://developers.google.com/chrome/chrome-frame/).

## Contributing

1. Fork
2. Hack
3. `rake test`
4. Send a pull request

All accepted pull requests will earn you commit and release rights.

## License

MIT
