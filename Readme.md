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
require 'pp'

parser = UserAgentParser::Parser.new
agent = parser.parse('Mozilla/5.0 (iPhone; U; fr; CPU iPhone OS 4_2_1 like Mac OS X; fr) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8C148a Safari/6533.18.5')

pp agent.name
# "Mobile Safari"

pp agent.version
#<UserAgentParser::Version 5.0.2>

pp agent.os
#<UserAgentParser::OperatingSystem iOS 4.2.1>

pp agent.os.name
# "iOS"

pp agent.os.version
#<UserAgentParser::Version 4.2.1>

pp agent.device
#<UserAgentParser::Device iPhone>

pp agent.device.name
# "iPhone"

# *Note*: #version, #os, and #device return nil if not detected.

# If you want to use a customized regexes.yml file, you can pass in your own
# path to the parser.
parser = UserAgentParser::Parser.new('some/new/path/to/regexes.yml')
parser.parse('...')
```

## The pattern database

The [ua-parser database](https://github.com/tobie/ua-parser/blob/master/regexes.yaml) is included via a [git submodule](http://help.github.com/submodules/). To update the database the submodule needs to be updated and the gem re-released (pull requests for this are very welcome!).

You can also specify the path to your own, updated and/or customised `regexes.yaml` file:

```ruby
path = '/some/path/to/regexes.yaml'
pattern_loader = UserAgentParser::FilePatternLoader.new(path)
parser = UserAgentParser::Parser.new(pattern_loader)
parser.parse('...')
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
