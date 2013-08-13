module SteamHldsLogParser

  # Listens to HLDS logs received via UDP on configured port
  #
  # @attr_reader [String] host Client host / IP
  # @attr_reader [Integer] port Client port to listen to
  # @attr_reader [Hash] options Client options
  class Client

    attr_reader :host, :port, :options

    # Creates a new client 
    #
    # @param [String] host Hostname / IP Address the server will be running
    # @param [Integer] port Port will be listening to
    # @param [Hash] options Other configuration options
    #
    # @option options [Symbol] :locale (:en) Set the language of returned content
    # @option options [Boolean] :display_kills (true) Enable kills / frags detail 
    # @option options [Boolean] :display_actions (true) Enable players actions / defuse / ... detail
    # @option options [Boolean] :display_changelevel (true) Enable changelevel (map) display
    # @option options [Class] :displayer Class that will be use to display content
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