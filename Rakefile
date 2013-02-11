require 'rake/testtask'
require 'bundler'

task :default => :test

desc "Run tests"
Rake::TestTask.new do |t|
  t.warning = true
  t.verbose = true
  t.pattern = "spec/*_spec.rb"
end

Bundler::GemHelper.install_tasks

# Does not actually get all families, as some are only listed in the regexes,
# but gives you a pretty good idea of what will be returned.
desc "Lists all unique family names for browsers and operating systems."
task :families do
  require 'pathname'
  require 'pp'

  root = Pathname(__FILE__).dirname
  path = root.join('vendor', 'ua-parser', 'test_resources')

  browser_families = paths_to_families([
    path.join('test_user_agent_parser.yaml'),
    path.join('firefox_user_agent_strings.yaml'),
    path.join('pgts_browser_list.yaml'),
  ])

  os_families = paths_to_families([
    path.join('test_user_agent_parser_os.yaml'),
    path.join('additional_os_tests.yaml'),
  ])

  device_families = paths_to_families([
    path.join('test_device.yaml'),
  ])

  puts "\n\nBrowser Families"
  puts browser_families.inspect

  puts "\n\nOS Families"
  puts os_families.inspect

  puts "\n\nDevice Families"
  puts device_families.inspect

  puts "\n\n"
  puts "Browser Family Count: #{browser_families.size}"
  puts "OS Family Count: #{os_families.size}"
  puts "Device Family Count: #{device_families.size}"
end

def paths_to_families(paths)
  require 'yaml'

  families = []

  paths.each do |path|
    data = YAML.load_file(path)
    test_cases = data.fetch('test_cases')
    families.concat test_cases.map { |row| row['family'] }
  end

  families.compact.uniq.sort
end
