# UserAgentParser [![Build Status](https://secure.travis-ci.org/toolmantim/user_agent_parser.png?branch=master)](http://travis-ci.org/toolmantim/user_agent_parser)

UserAgentParser is a simple, comprehensive Ruby gem for parsing user agent strings. It uses [BrowserScope](http://www.browserscope.org/)'s [parsing patterns](https://github.com/tobie/ua-parser).

## Requirements

* Ruby >= 1.9.2

Note: Ruby 1.8.7 is not supported due to the requirement for the newer psych YAML parser. If you can get it working on 1.8.7 please send a pull request.

## Installation

```bash
$ gem install user_agent_parser
```

## Example usage

```ruby
require 'user_agent_parser'
=> true
ua = UserAgentParser.parse 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.0;)'
=> #<UserAgentParser::UserAgent IE 9.0 (Windows Vista)>
ua.to_s
=> "IE 9.0 (Windows Vista)"
ua.family
=> "IE"
ua.version.to_s
=> "9.0"
ua.version[0]
=> 9
ua.version[1]
=> 0
ua.os.name
=> "Windows Vista"
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
...
    
Finished tests in 144.220280s, 89.0027 tests/s, 234.9739 assertions/s.

12836 tests, 33888 assertions, 0 failures, 0 errors, 0 skips
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