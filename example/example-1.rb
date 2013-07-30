require "rubygems"
require "hlds_log_parser"

class HldsDisplayer
  def initialize(data)
    puts data
  end
end

## These are default options
options = {
  :locale             => :en,
  :enable_kills       => false,
  :enable_actions     => false,
  :enable_changelevel => false
}

HldsLogParser::Client.new("127.0.0.1", 27035, options)
