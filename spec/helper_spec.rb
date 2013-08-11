require "simplecov"
require "coveralls"
require "rspec"

# Simplecov / Coverall configuration
SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter "/example/"
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
end

# Get the lib from the current path (not gem path)
require_relative "../lib/hlds_log_parser"
require_relative "../lib/hlds_log_parser/client"
require_relative "../lib/hlds_log_parser/handler"
require_relative "../lib/hlds_log_parser/displayer"

# Returns custom options as a Hash
def custom_options
  options = {
    :locale              => :fr,
    :display_kills       => false,
    :display_actions     => false,
    :display_changelevel => false,
    :displayer           => RSpecDisplayer
  }  
end
