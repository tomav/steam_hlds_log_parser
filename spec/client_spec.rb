require "helper_spec"

describe HldsLogParser::Client do

  it "returns a Hash for options" do
    expect(default_client.options.class).to eq(Hash)
  end

  it "should start and stop eventmachine loop" do
    EM.run {
      expect(capture_stdout { default_client.connect }).to eq("## 0.0.0.0:27035 => HLDS connected and sending data\n")
      EM.add_timer(0.5) {
        expect(capture_stdout { default_client.stop }).to eq("## 0.0.0.0:27035 => HLDS Log Parser stopped.\n")
      }
    }
  end

  it "returns custom displayer when configured" do
    expect(custom_client.options[:displayer]).to eq(RSpecDisplayer)
  end

end