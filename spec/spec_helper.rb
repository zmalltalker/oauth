begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end

require File.join(File.dirname(__FILE__), "..", "lib", "oauth")
$: << File.dirname(__FILE__)

Spec::Runner.configure do |config|
  config.mock_with :mocha
end
