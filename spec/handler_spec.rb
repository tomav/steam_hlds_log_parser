require "helper_spec"

describe HldsLogParser::Handler do

  it "returns host specified in constructor" do
    default_handler.host.should eq("0.0.0.0")
  end

  it "returns port specified in constructor" do
    default_handler.port.should eq(27035)
  end

  it "displays 'post_init' and 'unbind' ouput to console" do
    expect(capture_stdout { default_handler.unbind }).to eq("## 0.0.0.0:27035 => HLDS connected and sending data\n## 0.0.0.0:27035 => HLDS disconnected? No data is received.\n")
  end

  it "returns nil if log is not supported" do
    data = '# L 05/10/2000 - 12:34:56: I am a fake line of log'
    default_handler.receive_data(data).should eq(nil)
  end

  it "returns Hash on map_ends" do
    data = '# L 05/10/2000 - 12:34:56: Team "CT" scored "17" with "0" players"'
    expected = {:type=>"map_ends", :params=>{:winner=>"CT", :score=>"17"}}
    expect(default_handler.receive_data(data)).to eq(expected)
  end

  it "returns Hash on victory" do
    data = '# L 05/10/2000 - 12:34:56: Team "CT" triggered "CTs_Win" (CT "3") (T "0")'
    expected = {:type=>"victory", :params=>{:score_ct=>"3", :score_t=>"0"}}
    expect(default_handler.receive_data(data)).to eq(expected)
  end

  it "returns Hash on killed" do
    data = '# L 05/10/2000 - 12:34:56: "Killer | Player<66><STEAM_ID_LAN><TERRORIST>" killed "Killed | Player<60><STEAM_ID_LAN><CT>" with "ak47"'
    expected = {:type=>"kill", :params => {:killer_team=>"TE", :killer=>"Killer | Player",  :killed_team=>"CT", :killed=>"Killed | Player", :weapon=>"ak47"}}
    expect(default_handler.receive_data(data)).to eq(expected)
  end

  it "returns Hash on suicide" do
    data = '# L 05/10/2000 - 12:34:56: "Player<66><STEAM_ID_LAN><TERRORIST>" committed suicide with "worldspawn" (world)'
    expected = {:type=>"suicide", :params=>{:killed=>"Player"}}
    expect(default_handler.receive_data(data)).to eq(expected)
  end

  it "returns Hash on event" do
    data = '# L 05/10/2000 - 12:34:56: "Killer | Player<66><STEAM_ID_LAN><CT>" triggered "Defused_The_Bomb"'
    expected = {:type=>"event", :params=> {:person_team=>"CT", :person=>"Killer | Player", :event_item=>"Defused_The_Bomb", :event_i18n=>"defused the bomb"}}
    expect(default_handler.receive_data(data)).to eq(expected)
  end

  it "returns Hash on changelevel" do
    data = '# L 05/10/2000 - 12:34:56: Loading map "de_dust2"'
    expected = {:type=>"loading_map", :params=>{:map=>"de_dust2"}}
    expect(default_handler.receive_data(data)).to eq(expected)
  end

  it "returns 'Terrorist' for 'T'" do
    expect(default_handler.get_full_team_name('T')).to eq("Terrorist")
  end

  it "returns 'Counter-Terrorist' for 'CT'" do
    expect(default_handler.get_full_team_name('CT')).to eq("Counter-Terrorist")
  end

end
