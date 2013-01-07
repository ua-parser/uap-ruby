Gem::Specification.new do |gem|
  gem.name    = "user_agent_parser"
  gem.version = "1.0.2"

  gem.author      = "Tim Lucas"
  gem.email       = "t@toolmantim.com"
  gem.homepage    = "http://github.com/toolmantim/user_agent_parser"
  gem.summary     = "A simple, comprehensive Ruby gem for parsing user agent strings with the help of BrowserScope's UA database"
  gem.description = gem.summary
  gem.license     = "MIT"

  gem.files = %x{ git ls-files }.split("\n").select { |d| d =~ %r{^(MIT-LICENSE|Readme.md|lib/)} } + ['vendor/ua-parser/regexes.yaml']

  gem.required_ruby_version = '>= 1.8.7'
end
