require "rubygems"
require "hlds_log_parser"
require "flowdock"

## The displayer class that will be used to send content to Flowdock
class FlowdockPusher
  def initialize(data)
    # Source: https://github.com/flowdock/flowdock-api
    flow = Flowdock::Flow.new(:api_token => "12345678901234567890123456789012", :external_user_name => "HLDS-Live")
    flow.push_to_chat(:content => data)
  end
end

options = {
  :locale              => :fr,
  :display_kills       => true,
  :display_actions     => true,
  :display_changelevel => true,
  :displayer           => FlowdockPusher
}

HldsLogParser::Client.new("127.0.0.1", 27035, options).connect