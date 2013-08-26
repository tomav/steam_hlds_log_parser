require "helper_spec"

module SteamHldsLogParser

  describe "SteamHldsLogParser" do

    describe "Client" do

      context "when parameters are missing" do
        it "raises an exception" do
          expect { Client.new }.to raise_error(ArgumentError)
        end
      end

      subject(:default_client) { Client.new(RSpecDisplayer) }
      context "when a 'Client' is created with default options"
      it { should be_an_instance_of Client }
      it "has a 'displayer'" do
        expect(default_client.displayer).not_to be_nil      
        expect(default_client.displayer.class).to be(Class)
        expect(default_client.displayer).to be(RSpecDisplayer)
      end
      it "has a default 'options' Hash" do
        expect(default_client.displayer).not_to be_nil      
        expect(default_client.displayer.class).to be(Class)
      end
      it "has a default 'host'" do
        expect(default_client.options[:host]).not_to be_nil      
        expect(default_client.options[:host]).to eq("0.0.0.0")      
      end
      it "has a default 'port'" do
        expect(default_client.options[:port]).not_to be_nil      
        expect(default_client.options[:port]).to be(27115)
      end
      it "has a default 'locale'" do
        expect(default_client.options[:locale]).not_to be_nil      
        expect(default_client.options[:locale].class).to be(Symbol)
        expect(default_client.options[:locale]).to be(:en)
      end
      it "has a default 'display_kills'" do
        expect(default_client.options[:display_kills]).not_to be_nil      
        expect(default_client.options[:display_kills]).to be_true      
      end
      it "has a default 'display_actions'" do
        expect(default_client.options[:display_actions]).not_to be_nil      
        expect(default_client.options[:display_actions]).to be_true      
      end
      it "has a default 'display_changelevel'" do
        expect(default_client.options[:display_changelevel]).not_to be_nil      
        expect(default_client.options[:display_changelevel]).to be_true      
      end
      it "has a default 'display_chat'" do
        expect(default_client.options[:display_chat]).not_to be_nil      
        expect(default_client.options[:display_chat]).to be_true      
      end
      it "has a default 'display_team_chat'" do
        expect(default_client.options[:display_team_chat]).not_to be_nil      
        expect(default_client.options[:display_team_chat]).to be_true      
      end

      subject(:custom_client) { Client.new(RSpecDisplayer, custom_options) }
      context "when custom parameters are given"
      it { should be_an_instance_of Client }
      it "has a default 'options' Hash" do
        expect(custom_client.options).not_to be_nil      
        expect(custom_client.options.class).to be(Hash)      
      end
      it "has a custom 'host'" do
        expect(custom_client.options[:host]).not_to be_nil      
        expect(custom_client.options[:host]).to eq("127.0.0.1")      
      end
      it "has a custom 'port'" do
        expect(custom_client.options[:port]).not_to be_nil      
        expect(custom_client.options[:port]).to be(12345)  
      end
      it "has a custom 'locale'" do
        expect(custom_client.options[:locale]).not_to be_nil      
        expect(custom_client.options[:locale].class).to be(Symbol)      
        expect(custom_client.options[:locale]).to be(:fr)  
      end
      it "has a custom 'display_kills'" do
        expect(custom_client.options[:display_kills]).not_to be_nil      
        expect(custom_client.options[:display_kills]).to be_false  
      end
      it "has a custom 'display_actions'" do
        expect(custom_client.options[:display_actions]).not_to be_nil      
        expect(custom_client.options[:display_actions]).to be_false      
      end
      it "has a custom 'display_changelevel'" do
        expect(custom_client.options[:display_changelevel]).not_to be_nil      
        expect(custom_client.options[:display_changelevel]).to be_false      
      end
      it "has a custom 'display_chat'" do
        expect(custom_client.options[:display_chat]).not_to be_nil      
        expect(custom_client.options[:display_chat]).to be_false      
      end
      it "has a custom 'display_team_chat'" do
        expect(custom_client.options[:display_team_chat]).not_to be_nil      
        expect(custom_client.options[:display_team_chat]).to be_false      
      end

      describe "#start and #stop" do

        context "when 'start' and 'stop' are triggered one after the other"
        it "starts then stops an eventmachine with appropriate messages" do
          EM.run {
            expect(capture_stdout { default_client.start }).to eq("## 0.0.0.0:27115 => HLDS connected and sending data\n")
            EM.add_timer(0.2) {
              expect(capture_stdout { default_client.stop }).to eq("## 0.0.0.0:27115 => HLDS Log Parser stopped.\n")
            }
          }
        end

      end

    end

  end

end