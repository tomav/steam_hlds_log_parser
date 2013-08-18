require "rubygems"
require "steam_hlds_log_parser"

# Your displayer Class is what you will do with your data
class Formatter
  def initialize(data)
    # will 'puts' the translated content, using built-in Displayer
    SteamHldsLogParser::Displayer.new(data).display_translation
  end
end

# Setup the Client to use the 'Formatter' Class
# Options will be use default values (see example-2.rb)
SteamHldsLogParser::Client.new(Formatter).start
