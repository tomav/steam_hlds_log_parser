require "rubygems"
require "hlds_log_parser"

class HldsDisplayer
  def initialize(data)
    puts data
  end
end

HldsLogParser::Client.new("127.0.0.1", 4567)
