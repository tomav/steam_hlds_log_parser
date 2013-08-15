require "rubygems"
require "steam_hlds_log_parser"

class Formatter
  def initialize(data)
    # will 'puts' the translated content
    SteamHldsLogParser::Displayer.new(data).display_translation
  end
end


## These are default options
options = {
  :locale              => :en,
  :display_kills       => true,
  :display_actions     => true,
  :display_changelevel => true,
  :display_chat        => true,
  :display_team_chat   => true,
  :displayer           => Formatter
}

parser = SteamHldsLogParser::Client.new("127.0.0.1", 27035, options)
parser.start
