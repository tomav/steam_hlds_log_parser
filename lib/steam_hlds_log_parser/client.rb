module SteamHldsLogParser

  # Listens to HLDS logs received via UDP on configured port
  #
  # @attr_reader [Hash] options Client options
  #
  class Client

    attr_reader :displayer, :options

    # Creates a new client 
    #
    # @param [Class] displayer Callback class which will receive parsed content, do what you want with this class
    # @param [Hash] options Optional parameters to setup your client
    #
    # @option options [String] :host (0.0.0.0) IP Address the client will be running, usually localhost
    # @option options [Integer] :port (27115) Port will be listening to
    # @option options [Symbol] :locale (:en) Set the language of returned content
    # @option options [Boolean] :display_kills (true) Enable kills / frags detail 
    # @option options [Boolean] :display_actions (true) Enable players actions / defuse / ... detail
    # @option options [Boolean] :display_changelevel (true) Enable changelevel (map) display
    # @option options [Boolean] :display_chat (true) Enable chat ('say') display
    # @option options [Boolean] :display_team_chat (true) Enable chat ('say_team') display
    #
    def initialize(displayer, options = {})
      default_options = {
        :host                 => "0.0.0.0",
        :port                 => 27115,
        :locale               => :en,
        :display_kills        => true,
        :display_actions      => true,
        :display_changelevel  => true,
        :display_chat         => true,
        :display_team_chat    => true,
      }
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
        EM::open_datagram_socket(@options[:host], @options[:port], Handler, @displayer, @options)
      }       
     end

     # Stops the client
     def stop
       puts "## #{@options[:host]}:#{@options[:port]} => #{I18n.t('client_stop')}"
       EM::stop_event_loop
     end

  end
end