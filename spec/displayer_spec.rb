require "helper_spec"

module SteamHldsLogParser

  describe "SteamHldsLogParser" do

    before :all do
      @data           = {:type=>"victory", :params=>{:score_ct=>"3", :score_t=>"0"}}
      @displayer      = Displayer.new(@data)
    end

    describe "Displayer" do

      context "when 'data' is missing" do
        it "raises an exception" do
          expect { Displayer.new }.to raise_error(ArgumentError)
        end
      end

      context "when 'data' is given" do

        it "creates a 'Displayer'" do
          expect(@displayer).to be_an_instance_of Displayer
        end

        describe "#get_data" do
          it "returns 'data' given as argument" do
            expect(@displayer.get_data).not_to be_nil      
            expect(@displayer.get_data).to be(@data)      
          end
        end

        describe "#display_data" do
          it "displays 'data' given as argument" do
            expect(eval(capture_stdout { @displayer.display_data })).to eq(@data)
          end
        end

        describe "#get_translation" do
          it "returns translated 'data' given as argument" do
            expect(@displayer.get_translation).not_to be_nil      
            expect(@displayer.get_translation.class).to be(String)      
            expect(@displayer.get_translation).to eq("[CT] 3 - 0 [T]")      
          end
        end

        describe "#display_translation" do
          it "displays translated 'data' given as argument" do
            expect(capture_stdout { @displayer.display_translation }).to eq("[CT] 3 - 0 [T]\n")
          end
        end

      end

    end

  end

end
