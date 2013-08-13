module SteamHldsLogParser

  # Default Displayer
  #
  # @param [Hash] data Data returned by 'receive_data'
  #
  class Displayer

    attr_reader :data

    def initialize(data)
      @data = data
    end

    # Return 'data'
    # 
    # @return [Hash] Data processed by Handler class
    #
    def get_data
      return @data 
    end

    # Display 'data'
    def display_data
      puts get_data
    end

    # Return 'data' translation
    # 
    # @return [String] Translated data processed by Handler class
    #
    def get_translation
      return I18n.t(@data[:type], @data[:params]) unless @data[:type].nil?
    end

    # Display data translation
    def display_translation
      puts get_translation
    end

  end

end
