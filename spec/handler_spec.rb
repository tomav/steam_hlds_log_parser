require "helper_spec"

module SteamHldsLogParser

  describe "SteamHldsLogParser" do

    before :all do
      @client         = Client.new("0.0.0.0", 27035)
      @options        = @client.options
      @handler        = Handler.new("", "0.0.0.0", 27035, @options)
    end

    describe "Handler" do

      context "when parameters are missing" do
        it "raises an exception" do
          expect { Handler.new }.to raise_error(ArgumentError)
        end
      end

      context "when parameters are given" do
        subject { @handler }
  
        context "when 'host' and 'port' are given"
        it { should be_an_instance_of Handler }
        it "has a 'host'" do
          @handler.host.should_not be_nil      
          @handler.host.should eq("0.0.0.0")
        end
        it "has a 'port'" do
          @handler.port.should_not be_nil      
          @handler.port.should eq(27035)
        end

        describe "#post_init" do
          it "displays a console message when hlds connects" do
            capture_stdout { @handler.post_init }.should eq("## 0.0.0.0:27035 => HLDS connected and sending data\n")
          end
        end

        describe "#unbind" do
          it "displays a console message when hlds disconnects" do
            capture_stdout { @handler.unbind }.should eq("## 0.0.0.0:27035 => HLDS disconnected? No data is received.\n")
          end
        end

        describe "#receive_data" do

          context "when data is not supported" do
            it "returns anything" do
              data = '# L 05/10/2000 - 12:34:56: I am a fake line of log'
              @handler.receive_data(data).should eq(nil)
            end
          end

          context "when data is 'map_ends'" do
            it "returns Hash on map_ends" do
              data = '# L 05/10/2000 - 12:34:56: Team "CT" scored "17" with "0" players"'
              expected = {:type=>"map_ends", :params=>{:winner=>"CT", :score=>"17"}}
              @handler.receive_data(data).class.should eq(Hash)
              @handler.receive_data(data).should eq(expected)
            end
          end

          context "when data is 'victory'" do
            it "returns Hash on victory" do
              data = '# L 05/10/2000 - 12:34:56: Team "CT" triggered "CTs_Win" (CT "3") (T "0")'
              expected = {:type=>"victory", :params=>{:score_ct=>"3", :score_t=>"0"}}
              @handler.receive_data(data).class.should eq(Hash)
              @handler.receive_data(data).should eq(expected)
            end
          end

          context "when data is 'killed' (STEAM_ID_LAN)" do
            it "returns Hash on killed" do
              data = '# L 05/10/2000 - 12:34:56: "Killer | Player<66><STEAM_ID_LAN><TERRORIST>" killed "Killed | Player<60><STEAM_ID_LAN><CT>" with "ak47"'
              expected = {:type=>"kill", :params => {:killer_team=>"T", :killer=>"Killer | Player",  :killed_team=>"CT", :killed=>"Killed | Player", :weapon=>"ak47"}}
              @handler.receive_data(data).class.should eq(Hash)
              @handler.receive_data(data).should eq(expected)
            end
          end

          context "when data is 'killed' (STEAM_0:0:12345)" do
            it "returns Hash on killed" do
              data = '# L 05/10/2000 - 12:34:56: "Killer | Player<66><STEAM_0:0:12345><TERRORIST>" killed "Killed | Player<60><STEAM_0:0:12345><CT>" with "ak47"'
              expected = {:type=>"kill", :params => {:killer_team=>"T", :killer=>"Killer | Player",  :killed_team=>"CT", :killed=>"Killed | Player", :weapon=>"ak47"}}
              @handler.receive_data(data).class.should eq(Hash)
              @handler.receive_data(data).should eq(expected)
            end
          end

          context "when data is 'suicide' (STEAM_ID_LAN)" do
            it "returns Hash on suicide" do
              data = '# L 05/10/2000 - 12:34:56: "Player<66><STEAM_ID_LAN><TERRORIST>" committed suicide with "worldspawn" (world)'
              expected = {:type=>"suicide", :params=>{:killed=>"Player"}}
              @handler.receive_data(data).class.should eq(Hash)
              @handler.receive_data(data).should eq(expected)
            end
          end

          context "when data is 'suicide' (STEAM_0:0:12345)" do
            it "returns Hash on suicide" do
              data = '# L 05/10/2000 - 12:34:56: "Player<66><STEAM_0:0:12345><TERRORIST>" committed suicide with "worldspawn" (world)'
              expected = {:type=>"suicide", :params=>{:killed=>"Player"}}
              @handler.receive_data(data).class.should eq(Hash)
              @handler.receive_data(data).should eq(expected)
            end
          end

          context "when data is 'event' (STEAM_ID_LAN)" do
            it "returns Hash on event" do
              data = '# L 05/10/2000 - 12:34:56: "Killer | Player<66><STEAM_ID_LAN><CT>" triggered "Defused_The_Bomb"'
              expected = {:type=>"event", :params=> {:person_team=>"CT", :person=>"Killer | Player", :event_item=>"Defused_The_Bomb", :event_i18n=>"defused the bomb"}}
              @handler.receive_data(data).class.should eq(Hash)
              @handler.receive_data(data).should eq(expected)
            end
          end

          context "when data is 'event' (STEAM_0:0:12345)" do
            it "returns Hash on event" do
              data = '# L 05/10/2000 - 12:34:56: "Killer | Player<66><STEAM_0:0:12345><CT>" triggered "Defused_The_Bomb"'
              expected = {:type=>"event", :params=> {:person_team=>"CT", :person=>"Killer | Player", :event_item=>"Defused_The_Bomb", :event_i18n=>"defused the bomb"}}
              @handler.receive_data(data).class.should eq(Hash)
              @handler.receive_data(data).should eq(expected)
            end
          end

          context "when data is 'changelevel'" do
            it "returns Hash on changelevel" do
              data = '# L 05/10/2000 - 12:34:56: Loading map "de_dust2"'
              expected = {:type=>"loading_map", :params=>{:map=>"de_dust2"}}
              @handler.receive_data(data).class.should eq(Hash)
              @handler.receive_data(data).should eq(expected)
            end
          end

        end

        describe "#get_full_team_name" do

          context "when short name is given"
          it "returns full name" do
            @handler.get_full_team_name("T").should eq("Terrorist")
            @handler.get_full_team_name("CT").should eq("Counter-Terrorist")
          end

        end

        describe "#get_short_team_name" do

          context "when full name is given"
          it "returns short name" do
            @handler.get_short_team_name("TERRORIST").should eq("T")
            @handler.get_short_team_name("CT").should eq("CT")
          end

        end

      end

    end

  end

end
