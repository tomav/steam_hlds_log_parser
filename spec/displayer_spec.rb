require "helper_spec"

module HldsLogParser

  describe "HldsLogParser" do

    before :all do
      @data           = {:type=>"victory", :params=>{:score_ct=>"3", :score_t=>"0"}}
      @displayer      = HldsDisplayer.new(@data)
    end

    describe "HldsDisplayer" do

      context "when 'data' is missing" do
        it "raises an exception" do
          expect { HldsDisplayer.new }.to raise_error(ArgumentError)
        end
      end

      context "when 'data' is given" do

        it "creates a 'HldsDisplayer'" do
          @displayer.should be_an_instance_of HldsDisplayer
        end

        describe "#get_data" do
          it "returns 'data' given as argument" do
            @displayer.get_data.should_not be_nil      
            @displayer.get_data.should be(@data)      
          end
        end

        describe "#display_data" do
          it "displays 'data' given as argument" do
            eval(capture_stdout { @displayer.display_data }).should eq(@data)
          end
        end

        describe "#get_translation" do
          it "returns translated 'data' given as argument" do
            @displayer.get_translation.should_not be_nil      
            @displayer.get_translation.class.should be(String)      
            @displayer.get_translation.should eq("[CT] 3 - 0 [T]")      
          end
        end

        describe "#display_translation" do
          it "displays translated 'data' given as argument" do
            capture_stdout { @displayer.display_translation }.should eq("[CT] 3 - 0 [T]\n")
          end
        end

      end

    end

  end

end
