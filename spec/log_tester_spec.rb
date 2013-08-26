require "helper_spec"

module SteamHldsLogParser

  describe "SteamHldsLogParser" do

    before :all do
      @client         = Client.new(RSpecDisplayer)
      @handler        = Handler.new("", @client.displayer, @client.options)
    end

    describe "LogTester" do

      context "when data come from a log file (2000+ lines) using STEAM_ID_LAN, STEAM_0:0:12345 and BOT" do
        it "returns a Hash on matching patterns without any error" do
          File.open('spec/logs/L0000000.log', 'r') do |f|
            f.each_line do |line|
              obj = @handler.receive_data(line)
              unless obj.nil?
                expect(obj.class).to be(RSpecDisplayer)
                hash = obj.data
                string = Displayer.new(hash).get_translation
                expect(string.class).to be(String)
              end
            end
          end
        end
      end

    end
  end
end
