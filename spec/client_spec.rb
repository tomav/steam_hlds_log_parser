require "helper_spec"

module SteamHldsLogParser

  describe "SteamHldsLogParser" do

    before :all do
      @client         = Client.new("0.0.0.0", 27035)
      @options        = @client.options
      @custom_options = custom_options
      @custom_client  = Client.new("127.0.0.1", 27045, @custom_options)
    end

    describe "Client" do

      it "raises an exception when parameters are missing" do
        expect { Client.new }.to raise_error(ArgumentError)
      end

      subject { @client }
      context "when a 'Client' is created without options"
      it { should be_an_instance_of Client }
      it "has a 'host'" do
        @client.host.should_not be_nil      
        @client.host.should eq("0.0.0.0")
      end
      it "has a 'port'" do
        @client.port.should_not be_nil      
        @client.port.should eq(27035)
      end
      it "has a default 'options' Hash" do
        @client.options.should_not be_nil      
        @client.options.should_not be(nil)
        @client.options.class.should be(Hash)
        @client.options.should eq(@options)
      end

      subject(:custom_client) { @custom_client }
      context "when custom options are given"
      it "can get a custom 'options' Hash" do
        @custom_client.options.should_not be_nil      
        @custom_client.options.class.should be(Hash)
        @custom_client.options.should eq(@custom_options)
        @custom_client.options[:displayer].should eq(RSpecDisplayer)
        @custom_client.options[:locale].should be(:fr)
        @custom_client.options[:display_kills].should be(false)
        @custom_client.options[:display_actions].should be(false)
        @custom_client.options[:display_changelevel].should be(true)
      end

      describe "#start and #stop" do

        context "when 'start' and 'stop' are triggered one after the other"
        it "starts then stops an eventmachine with appropriate messages" do
          EM.run {
            capture_stdout { @client.start }.should eq("## 0.0.0.0:27035 => HLDS connected and sending data\n")
            EM.add_timer(0.2) {
              capture_stdout { @client.stop }.should eq("## 0.0.0.0:27035 => HLDS Log Parser stopped.\n")
            }
          }
        end

      end

    end

  end

end