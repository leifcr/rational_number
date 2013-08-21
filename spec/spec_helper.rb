$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'bundler/setup'
require 'fileutils'

if ENV['TRAVIS']
  require 'coveralls'
  Coveralls.wear!
elsif ENV['COVERAGE'] && RUBY_VERSION > "1.8"
  require 'simplecov'
  SimpleCov.start do
    add_filter 'spec'
  end
end

require 'rational_number'

Bundler.require(:default, :test)

RSpec.configure do |c|

end
