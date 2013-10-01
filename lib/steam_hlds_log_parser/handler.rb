module SteamHldsLogParser

  # Process data received by 'Client'
  #
  # @attr_reader [Class] displayer Callback
  # @attr_reader [Hash] options Client options
  #
  class Handler < EM::Connection

    attr_reader :displayer, :options

    # Initialize Handler from Client options
    #
    # @param [Class] displayer Class to call when data is parsed
    # @param [Hash] options Client configuration options
    #
    def initialize(displayer, options)
      @displayer  = displayer
      @options    = options
    end

    # Triggered when HLDS connects
    def post_init
      puts "## #{@options[:host]}:#{@options[:port]} => #{I18n.t('client_connect')}"
    end

    # Triggered when HLDS disconnects
    def unbind
      puts "## #{@options[:host]}:#{@options[:port]} => #{I18n.t('client_disconnect')}" 
    end

    # Get data from Client and parse using Regexp
    #
    # * match end of map, with winner team and score
    # * match the end of round, with score and victory type
    # * match who killed who with what (frags)
    # * match suicides
    # * match who did what (defuse, drop the bomb...)
    # * match changelevel
    # * match chat (say)
    # * match team chat (say_team)
    # * user connections / disconnections
    #
    # @param [String] data Data received by Client from HLDS server (a line of log)
    #
    def receive_data(data)

      # L 05/10/2000 - 12:34:56: Team "CT" scored "17" with "0" players
      if data.gsub(/Team "([A-Z]+)" scored "(\d+)" with "(\d+)"/).count > 0
        winner, winner_score = data.match(/Team "(.+)" scored "(\d+)" with/).captures
        content = { :type => 'map_ends', :params => { :winner => get_short_team_name(winner), :score => winner_score } } 

      # L 05/10/2000 - 12:34:56: Team "CT" triggered "CTs_Win" (CT "3") (T "0")
      elsif data.gsub(/: Team "[A-Z]+" triggered/).count > 0
        winner, type, score_ct, score_t = data.match(/Team "([A-Z]+)" triggered "([A-Za-z_]+)" \(CT "(\d+)"\) \(T "(\d+)"\)/i).captures
        content = { :type => 'victory', :params => { :score_ct => score_ct, :score_t => score_t } }

      # L 05/10/2000 - 12:34:56: "Killer | Player<66><STEAM_ID_LAN><TERRORIST>" killed "Killed | Player<60><STEAM_ID_LAN><CT>" with "ak47"
      elsif @options[:display_kills] && data.gsub(/(\>" killed ")/).count > 0
        killer, killer_team, killed, killed_team, weapon = data.match(/"(.+)<\d+><.+><([A-Z]+)>" killed "(.+)<\d+><.+><([A-Z]+)>" with "(.+)"/i).captures
        content = { :type => 'kill', :params => { :killer_team => get_short_team_name(killer_team), :killer => killer, :killed_team => get_short_team_name(killed_team), :killed => killed, :weapon => weapon } }

      # L 05/10/2000 - 12:34:56: "Player<66><STEAM_ID_LAN><TERRORIST>" committed suicide with "worldspawn" (world)
      elsif @options[:display_kills] && data.gsub(/>" committed suicide/).count > 0
        killed = data.match(/: "(.+)<\d+>/).captures.first
        content = { :type => 'suicide', :params => { :killed => killed } }

      # L 05/10/2000 - 12:34:56: "Killer | Player<66><STEAM_ID_LAN><CT>" triggered "Defused_The_Bomb"
      elsif @options[:display_actions] && data.gsub(/<.+><.+>" triggered "(.+)"$/).count > 0
        person, person_team, event = data.match(/: "(.+)<\d+><.+><([A-Z]+)>" triggered "(.+)"/i).captures
        content = { :type => 'event', :params => { :person_team => get_short_team_name(person_team), :person => person, :event_item => event, :event_i18n => I18n.t(event.downcase)} }

      # L 05/10/2000 - 12:34:56: Loading map "de_dust2"
      elsif @options[:display_changelevel] && data.gsub(/: Loading map "(.+)"/).count > 0
        map = data.match(/: Loading map "(.+)"/i).captures.first
        content = { :type => 'loading_map', :params => { :map => map } }

      # L 05/10/2000 - 12:34:56: "Player<15><STEAM_0:0:12345><TERRORIST>" say "gg" (dead)
      elsif @options[:display_chat] && data.gsub(/: "(.+)<\d+><.+><([A-Z]+)>" say "(.+)"/).count > 0
        player, player_team, message = data.match(/: "(.+)<\d+><.+><([A-Z]+)>" say "(.+)"/i).captures
        content = { :type => 'chat', :params => { :player => player, :player_team => get_short_team_name(player_team), :chat => message } }

      # L 05/10/2000 - 12:34:56: "Player<15><STEAM_0:0:12345><TERRORIST>" say_team "Rush B" (dead)
      elsif @options[:display_team_chat] && data.gsub(/: "(.+)<\d+><.+><([A-Z]+)>" say_team "(.+)"/).count > 0
        player, player_team, message = data.match(/: "(.+)<\d+><.+><([A-Z]+)>" say_team "(.+)"/i).captures
        content = { :type => 'team_chat', :params => { :player => player, :player_team => get_short_team_name(player_team), :chat => message } }

      # L 05/10/2000 - 12:34:56: "Player<73><STEAM_ID_LAN><>" connected, address "192.168.4.186:1339"
      elsif @options[:display_connect] && data.gsub(/: "(.+)<\d+><.+>" connected, address "(.+):(.+)"/).count > 0
        player, ip, port = data.match(/: "(.+)<\d+><.+>" connected, address "(.+):(.+)"/i).captures
        content = { :type => 'connect', :params => { :player => player, :ip => ip, :port => port } }

      # L 05/10/2000 - 12:34:56: "Player<73><STEAM_ID_LAN><TERRORIST>" disconnected
      elsif @options[:display_disconnect] && data.gsub(/: "(.+)<\d+><.+><(.+)>" disconnected/).count > 0
        player, player_team = data.match(/: "(.+)<\d+><.+><(.+)>" disconnected/i).captures
        content = { :type => 'disconnect', :params => { :player => player, :player_team => get_short_team_name(player_team) } }

      end

      # no matching pattern, no output
      @displayer.new(content) unless content.nil?

    end

    # Format team name with long format (textual)
    #
    # @param [String] winner Round winner (+CT+ or +T+) from logs
    #
    # @return [String] Full team name from translation files
    #
    def get_full_team_name(winner)
      case winner
      when "T"
        return "#{I18n.t('full_team_name_te')}"
      when "CT"
        return "#{I18n.t('full_team_name_ct')}"
      else
      end
    end

    # Format team name with short format (initials)
    #
    # @param [String] team Round winner (+CT+ or +TERRORIST+) from logs
    #
    # @return [String] Short team name from translation files
    #
    def get_short_team_name(team)
      case team
      when "TERRORIST"
        return "#{I18n.t('short_team_name_te')}"
      when "CT"
        return "#{I18n.t('short_team_name_ct')}"
      else
      end
    end

  end
end