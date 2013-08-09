require "helper_spec"

describe HldsLogParser::Client do

  it "returns a Hash for options" do
    expect(default_client.options.class).to eq(Hash)
  end

  it "should have started eventmachine" do
    default_client.connect do
      EventMachine.reactor_running?.should be_true
      done
    end
  end

  it "returns custom displayer when configured" do
    expect(custom_client.options[:displayer]).to eq(RSpecDisplayer)
  end

end