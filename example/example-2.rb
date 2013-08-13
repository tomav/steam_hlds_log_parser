require "rubygems"
require "steam_hlds_log_parser"
# require "flowdock"

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

options = {
  :locale              => :fr,
  :display_kills       => true,
  :display_actions     => true,
  :display_changelevel => true,
  :displayer           => FlowdockPusher
}

SteamHldsLogParser::Client.new("127.0.0.1", 27035, options).start