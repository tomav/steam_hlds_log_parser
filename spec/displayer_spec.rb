require "helper_spec"

describe HldsLogParser::HldsDisplayer do

  data  = {:type=>"victory", :params=>{:score_ct=>"3", :score_t=>"0"}}
  dsp   = HldsLogParser::HldsDisplayer.new(data)

  it "returns the given Hash" do
    expect(dsp.get_data).to eq(data)
  end

  it "returns nothing, just displays that Hash" do
    expect( eval(capture_stdout { dsp.display_data }) ).to eq(data)
  end

  it "returns a translated content from a Hash" do
    expect(dsp.get_translation).to eq("[CT] 3 - 0 [T]")
  end

  it "returns nothing, just displays the translated content from the Hash" do
    
    expect( capture_stdout { dsp.display_translation } ).to eq("[CT] 3 - 0 [T]\n")
  end


end
