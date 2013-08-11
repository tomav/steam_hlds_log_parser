module HldsLogParser

  # Default Displayer
  #
  # ==== Attributes
  #
  # * +data+ - Data processed by 'receive_data' (Hash)
  #
  class HldsDisplayer

    attr_reader :data

    def initialize(data)
      @data = data
    end

    def get_data
      return @data 
    end

    def display_data
      puts get_data
    end

    def get_translation
      return I18n.t(@data[:type], @data[:params]) unless @data[:type].nil?
    end

    def display_translation
      puts get_translation
    end

  end

end
