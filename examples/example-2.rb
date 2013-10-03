require "rubygems"
require "steam_hlds_log_parser"

# Your displayer Class is what you will do with your data
class Formatter
  def initialize(data)
    # will 'puts' the translated content, using built-in Displayer
    SteamHldsLogParser::Displayer.new(data).display_translation
  end
end

# These are default options
options = {
  :host                 => "0.0.0.0",
  :port                 => 27115,
  :locale               => :en,
  :display_end_map      => true,
  :display_end_round    => true,
  :display_kills        => true,
  :display_actions      => true,
  :display_changelevel  => true,
  :display_chat         => true,
  :display_team_chat    => true,
  :display_connect      => true,
  :display_disconnect   => true
}

parser = SteamHldsLogParser::Client.new(Formatter, options)
parser.start
