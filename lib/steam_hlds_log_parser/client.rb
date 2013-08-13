module SteamHldsLogParser

  class Client

    attr_reader :host, :port, :options

    # Creates a new client 
    #
    # @host [String] Hostname / IP Address the server will be running
    # @port [Integer] Port to listen to
    # @options [Hash] Other options
    #
    # ==== Options
    #
    # * +locale+ - Set the language of returned content
    # * +display_kills+ Enable kills / frags detail (default=true)
    # * +display_actions+ Enable players actions / defuse / ... detail (default=true)
    # * +display_changelevel+ Enable changelevel (map) display (default=true)
    # * +displayer+ Class that will be use to display content (default=HldsReturnDisplayer)
    #
    def initialize(host, port, options = {})
      default_options = {
        :locale              => :en,
        :display_kills       => true,
        :display_actions     => true,
        :display_changelevel => true
      }
      @host, @port  = host, port
      @options      = default_options.merge(options)
     end

     # Starts the client which will receive HLDS logs (using UDP)
     def start
      # setting locale
      I18n.locale = @options[:locale] || I18n.default_locale
      EM.run {
        # catch CTRL+C
        Signal.trap("INT")  { EM.stop }
        Signal.trap("TERM") { EM.stop }
        # Let's start
        EM::open_datagram_socket(@host, @port, Handler, @host, @port, @options)
      }       
     end

     # Stops the client
     def stop
       puts "## #{@host}:#{@port} => #{I18n.t('client_stop')}"
       EM::stop_event_loop
     end

  end
end