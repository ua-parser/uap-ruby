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