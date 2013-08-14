require "simplecov"
require "coveralls"
require "rspec"

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
    :locale              => :fr,
    :display_kills       => false,
    :display_actions     => false,
    :display_changelevel => true,
    :displayer           => RSpecDisplayer
  }  
end
