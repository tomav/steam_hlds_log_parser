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
        default_client.displayer.should_not be_nil      
        default_client.displayer.class.should be(Class)
        default_client.displayer.should be(RSpecDisplayer)
      end
      it "has a default 'options' Hash" do
        default_client.options.should_not be_nil      
        default_client.options.class.should be(Hash)
      end
      it "has a default 'host'" do
        default_client.options[:host].should_not be_nil      
        default_client.options[:host].should eq("0.0.0.0")
      end
      it "has a default 'port'" do
        default_client.options[:port].should_not be_nil      
        default_client.options[:port].should eq(27115)
      end
      it "has a default 'locale'" do
        default_client.options[:locale].should_not be_nil      
        default_client.options[:locale].class.should eq(Symbol)      
        default_client.options[:locale].should eq(:en)
      end
      it "has a default 'display_kills'" do
        default_client.options[:display_kills].should_not be_nil      
        default_client.options[:display_kills].should be(true)
      end
      it "has a default 'display_actions'" do
        default_client.options[:display_actions].should_not be_nil      
        default_client.options[:display_actions].should be(true)
      end
      it "has a default 'display_changelevel'" do
        default_client.options[:display_changelevel].should_not be_nil      
        default_client.options[:display_changelevel].should be(true)
      end
      it "has a default 'display_chat'" do
        default_client.options[:display_chat].should_not be_nil      
        default_client.options[:display_chat].should be(true)
      end
      it "has a default 'display_team_chat'" do
        default_client.options[:display_team_chat].should_not be_nil      
        default_client.options[:display_team_chat].should be(true)
      end

      subject(:custom_client) { Client.new(RSpecDisplayer, custom_options) }
      context "when custom parameters are given"
      it { should be_an_instance_of Client }
      it "has a default 'options' Hash" do
        custom_client.options.should_not be_nil      
        custom_client.options.should_not be(nil)
        custom_client.options.class.should be(Hash)
      end
      it "has a custom 'host'" do
        custom_client.options[:host].should_not be_nil      
        custom_client.options[:host].should eq("127.0.0.1")
      end
      it "has a custom 'port'" do
        custom_client.options[:port].should_not be_nil      
        custom_client.options[:port].should eq(12345)
      end
      it "has a custom 'locale'" do
        custom_client.options[:locale].should_not be_nil      
        custom_client.options[:locale].class.should eq(Symbol)      
        custom_client.options[:locale].should eq(:fr)
      end
      it "has a custom 'display_kills'" do
        custom_client.options[:display_kills].should_not be_nil      
        custom_client.options[:display_kills].should be(false)
      end
      it "has a custom 'display_actions'" do
        custom_client.options[:display_actions].should_not be_nil      
        custom_client.options[:display_actions].should be(false)
      end
      it "has a custom 'display_changelevel'" do
        custom_client.options[:display_changelevel].should_not be_nil      
        custom_client.options[:display_changelevel].should be(false)
      end
      it "has a custom 'display_chat'" do
        custom_client.options[:display_chat].should_not be_nil      
        custom_client.options[:display_chat].should be(false)
      end
      it "has a custom 'display_team_chat'" do
        custom_client.options[:display_team_chat].should_not be_nil      
        custom_client.options[:display_team_chat].should be(false)
      end

      describe "#start and #stop" do

        context "when 'start' and 'stop' are triggered one after the other"
        it "starts then stops an eventmachine with appropriate messages" do
          EM.run {
            capture_stdout { default_client.start }.should eq("## 0.0.0.0:27115 => HLDS connected and sending data\n")
            EM.add_timer(0.2) {
              capture_stdout { default_client.stop }.should eq("## 0.0.0.0:27115 => HLDS Log Parser stopped.\n")
            }
          }
        end

      end

    end

  end

end