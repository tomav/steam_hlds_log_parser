module HldsLogParser

  # Display Hash returned by Handler
  #
  # ==== Attributes
  #
  # * +data+ - Data processed by 'receive_data'
  #
  class HldsHashDisplayer
    def initialize(data)
      puts data
    end
  end

  # Return translated Hash returned by Handler
  #
  # ==== Attributes
  #
  # * +hash+ - Data to be processed !by 'receive_data'
  #
  class HldsI18nProcessor

    attr_reader :content

    def initialize(hash)
      @content = I18n.t(hash[:type], hash[:params])
    end

  end

  # Display translated Hash returned by Handler
  #
  # ==== Attributes
  #
  # * +hash+ - Data to be processed !by 'receive_data'
  #
  class HldsI18nDisplayer
    def initialize(hash)
      unless hash.nil?
        obj = HldsI18nProcessor.new(hash)
        puts "#{obj.content}"
      end
    end
  end

end