require "rubygems"
require "steam_hlds_log_parser"
require "flowdock"

## The displayer class that will be used to send content to Flowdock
class FlowdockPusher
  def initialize(data)
    # Get translated data 
    content = SteamHldsLogParser::Displayer.new(data).get_translation
    # Source: https://github.com/flowdock/flowdock-api
    flow = Flowdock::Flow.new(:api_token => "12345678901234567890123456789012", :external_user_name => "HLDS-Live")
    flow.push_to_chat(:content => content)
  end
end

# Custom options for a basic match stream on Flowdock
options = {
  :display_kills       => false,
  :display_chat        => false,
  :display_team_chat   => false
}

SteamHldsLogParser::Client.new(FlowdockPusher, options).start