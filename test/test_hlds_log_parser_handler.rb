require "hlds_log_parser"
require "test/unit"

class HandlerTest < Test::Unit::TestCase

  # Helpers

  def default_client
    options = { :test => true }
    return HldsLogParser::Client.new("0.0.0.0", 27035, options)
  end

  def default_handler
    options = default_client.options
    return HldsLogParser::Handler.new("", "0.0.0.0", 27035, options)
  end

  # Tests

  def test_match_score
    data = '# L 05/10/2000 - 12:34:56: Team "CT" scored "17" with "0" players"'
    assert_equal( {:type=>"map_ends", :params=>{"winner"=>"CT", :score=>"17"}}, default_handler.receive_data(data) )
  end

  def test_match_victory
    data = '# L 05/10/2000 - 12:34:56: Team "CT" triggered "CTs_Win" (CT "3") (T "0")'
    assert_equal( {:type=>"victory", :params=>{:score_ct=>"3", :score_t=>"0"}}, default_handler.receive_data(data) )
  end

  def test_match_killed
    data = '# L 05/10/2000 - 12:34:56: "Killer | Player<66><STEAM_ID_LAN><TERRORIST>" killed "Killed | Player<60><STEAM_ID_LAN><CT>" with "ak47"'
    assert_equal( {:type=>"kill", :params => {:killer_team=>"TE", :killer=>"Killer | Player",  :killed_team=>"CT", :killed=>"Killed | Player", :weapon=>"ak47"}}, default_handler.receive_data(data))
  end

  def test_match_suicide
    data = '# L 05/10/2000 - 12:34:56: "Player<66><STEAM_ID_LAN><TERRORIST>" committed suicide with "worldspawn" (world)'
    assert_equal( {:type=>"suicide", :params=>{:killed=>"Player"}}, default_handler.receive_data(data) )
  end
  
  def test_match_action
    data = '# L 05/10/2000 - 12:34:56: "Killer | Player<66><STEAM_ID_LAN><CT>" triggered "Defused_The_Bomb"'
    assert_equal( {:type=>"event", :params=> {:person_team=>"CT", :person=>"Killer | Player", :event_item=>"Defused_The_Bomb", :event_i18n=>"defused the bomb"}}, default_handler.receive_data(data) )
  end
    
  def test_match_changelevel
    data = '# L 05/10/2000 - 12:34:56: Loading map "de_dust2"'
    assert_equal( {:type=>"loading_map", :params=>{:map=>"de_dust2"}}, default_handler.receive_data(data) )
  end
    

end

