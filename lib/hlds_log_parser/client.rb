module HldsLogParser

  class Client

    attr_reader :host, :port, :options

    # Creates a new client which will receive HLDS logs (using UDP)
    #
    # ==== Attributes
    #
    # * +host+ - Hostname / IP Address the server will be running
    # * +port+ - Port to listen to
    # * +options+ Hash for others options
    #
    # ==== Options
    #
    # * +locale+ - Set the language of returned content
    # * +display_kills+ Enable kills / frags detail (default=true)
    # * +display_actions+ Enable players actions / defuse / ... detail (default=true)
    # * +display_changelevel+ Enable changelevel (map) display (default=true)
    # * +displayer+ Class that will be use to display content (default=HldsReturnDisplayer)
    # * +test+ Does not print content, used for unit test (default=false)
    #
    def initialize(host, port, options = {})
      default_options = {
        :locale              => :en,
        :display_kills       => true,
        :display_actions     => true,
        :display_changelevel => true,
        :test                => false
      }
      @host, @port  = host, port
      @options      = default_options.merge(options)

     end

     def connect
      EM.run {
        # setting locale
        I18n.locale = @options[:locale] || I18n.default_locale
        # catch CTRL+C
        Signal.trap("INT")  { EM.stop }
        Signal.trap("TERM") { EM.stop }
        # Let's start
        EM::open_datagram_socket(@host, @port, Handler, @host, @port, @options)
      }       
     end

  end
end