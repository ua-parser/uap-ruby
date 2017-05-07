Gem::Specification.new do |gem|
  gem.name    = "user_agent_parser"
  gem.version = "2.3.1"

  gem.author      = "Tim Lucas"
  gem.email       = "t@toolmantim.com"
  gem.homepage    = "https://github.com/ua-parser/uap-ruby"
  gem.summary     = "A simple, comprehensive Ruby gem for parsing user agent strings with the help of BrowserScope's UA database"
  gem.description = gem.summary
  gem.license     = "MIT"
  gem.executables = ['user_agent_parser']

  gem.files = %x{ git ls-files }.split("\n").select { |d| d =~ %r{^(MIT-LICENSE|Readme.md|lib|bin/)} } + ['vendor/uap-core/regexes.yaml']

  gem.required_ruby_version = '>= 1.8.7'
end
