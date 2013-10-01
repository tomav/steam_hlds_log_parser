require "simplecov"
require "coveralls"
require "rspec"

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

# Simplecov / Coverall configuration
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start do
  add_filter "/examples/"
  add_filter "/spec/"
end

# Get ouput content of the given block
# Source: https://github.com/cldwalker/hirb/blob/master/test/test_helper.rb
def capture_stdout(&block)
  original_stdout = $stdout
  $stdout = fake = StringIO.new
  begin
    yield
  ensure
    $stdout = original_stdout
  end
 fake.string
end

class RSpecDisplayer
  attr_reader :data
  def initialize(data)
    @data = data
  end
end

require "steam_hlds_log_parser"

# Returns custom options as a Hash
def custom_options
  options = {
    :host                 => "127.0.0.1",
    :port                 => 12345,
    :locale               => :fr,
    :display_kills        => false,
    :display_actions      => false,
    :display_changelevel  => false,
    :display_chat         => false,
    :display_team_chat    => false,
    :display_connect      => false,
    :display_disconnect   => false,
    :displayer            => RSpecDisplayer
  }  
end
