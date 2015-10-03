require "coveralls"
require "webmock/rspec"
Coveralls.wear!

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "checklister"

def load_fixture(name)
  File.new(File.dirname(__FILE__) + "/fixtures/#{name}.json").read
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
