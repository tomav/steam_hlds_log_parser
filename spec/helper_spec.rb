require "simplecov"
require "coveralls"
require "em-rspec"
SimpleCov.start do
  add_filter "/example/"
  add_filter "/spec/"
end

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

require "hlds_log_parser"

def default_options
  default_client.options
end

def custom_options
  options = {
    :locale              => :fr,
    :display_kills       => false,
    :display_actions     => false,
    :display_changelevel => false,
    :displayer           => RSpecDisplayer
  }  
end

def default_client
  return HldsLogParser::Client.new("0.0.0.0", 27035)
end

def default_handler
  options = default_client.options
  return HldsLogParser::Handler.new("", "0.0.0.0", 27035, default_options)
end

def custom_client
  return HldsLogParser::Client.new("0.0.0.0", 27035, custom_options)
end

