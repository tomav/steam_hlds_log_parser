require "rubygems"
require "hlds_log_parser"

## These are default options
options = {
  :locale              => :en,
  :display_kills       => true,
  :display_actions     => true,
  :display_changelevel => true,
  # Except this one, but you will probably use your own Displayer
  :displayer           => HldsLogParser::HldsPutsDisplayer
}

parser = HldsLogParser::Client.new("127.0.0.1", 27035, options)
parser.connect
