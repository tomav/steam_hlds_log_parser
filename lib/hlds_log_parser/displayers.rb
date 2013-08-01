module HldsLogParser

  # Displayer which 'return' content
  #
  # ==== Attributes
  #
  # * +data+ - Data processed by 'receive_data'
  #
  class HldsReturnDisplayer
    def initialize(data)
      return data
    end
  end

  # Displayer which 'puts' content
  #
  # ==== Attributes
  #
  # * +data+ - Data processed by 'receive_data'
  #
  class HldsPutsDisplayer
    def initialize(data)
      puts data
    end
  end
  
end