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
    assert_equal( "Map ends: CT score => 17", default_handler.receive_data(data) )
  end

  def test_match_score
    data = '# L 05/10/2000 - 12:34:56: Team "CT" scored "17" with "0" players"'
    assert_equal( "Map ends: CT score => 17", default_handler.receive_data(data) )
  end

  def test_match_victory
    data = '# L 05/10/2000 - 12:34:56: Team "CT" triggered "CTs_Win" (CT "3") (T "0")'
    assert_equal( "[CT] 3 - 0 [TE] => Counter-Terrorists Win", default_handler.receive_data(data) )
  end

  def test_match_killed
    data = '# L 05/10/2000 - 12:34:56: "Killer | Player<66><STEAM_ID_LAN><TERRORIST>" killed "Killed | Player<60><STEAM_ID_LAN><CT>" with "ak47"'
    assert_equal( "[TE] Killer | Player killed [CT] Killed | Player with ak47", default_handler.receive_data(data) )
  end

  def test_match_suicide
    data = '# L 05/10/2000 - 12:34:56: "Player<66><STEAM_ID_LAN><TERRORIST>" committed suicide with "worldspawn" (world)'
    assert_equal( "Player committed suicide", default_handler.receive_data(data) )
  end
  
  def test_match_action
    data = '# L 05/10/2000 - 12:34:56: "Killer | Player<66><STEAM_ID_LAN><CT>" triggered "Defused_The_Bomb"'
    assert_equal( "[CT] Killer | Player defused the bomb", default_handler.receive_data(data) )
  end
    
  def test_match_changelevel
    data = '# L 05/10/2000 - 12:34:56: Loading map "de_dust2"'
    assert_equal( "Loading map de_dust2", default_handler.receive_data(data) )
  end
    

end

