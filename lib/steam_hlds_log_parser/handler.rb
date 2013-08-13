module SteamHldsLogParser

  class Handler < EM::Connection

    attr_reader :host, :port, :options

    # Initialize Handler from Client options
    #
    # @host [String] Hostname / IP Address the server will be running
    # @port [Integer] Port to listen to
    # @options [Hash] Other options
    #
    def initialize(host, port, options)
      @host, @port, @options = host, port, options
    end

    # Triggered when HLDS connects
    def post_init
      puts "## #{@host}:#{@port} => #{I18n.t('client_connect')}"
    end

    # Triggered when HLDS disconnects
    def unbind
      puts "## #{@host}:#{@port} => #{I18n.t('client_disconnect')}" 
    end

    # Get data from Client and parse using Regexp
    #
    # * match end of map, with winner team and score
    # * match the end of round, with score and victory type
    # * match who killed who with what (frags)
    # * match suicides
    # * match who did what (defuse, drop the bomb...)
    # * match changelevel
    #
    # @data [String] Data received by Client from HLDS server (a line of log)
    #
    def receive_data(data)

      # L 05/10/2000 - 12:34:56: Team "CT" scored "17" with "0" players
      if data.gsub(/Team "(.+)" scored "(\d+)" with "(\d+)"/).count > 0
        winner, winner_score = data.match(/Team "(.+)" scored "(\d+)" with/).captures
        content = { :type => 'map_ends', :params => { :winner => get_short_team_name(winner), :score => winner_score } } 

      # L 05/10/2000 - 12:34:56: Team "CT" triggered "CTs_Win" (CT "3") (T "0")
      elsif data.gsub(/(: Team ")/).count > 0
        winner, type, score_ct, score_t = data.match(/Team "([A-Z]+)" triggered "([A-Za-z_]+)" \(CT "(\d+)"\) \(T "(\d+)"\)/i).captures
        content = { :type => 'victory', :params => { :score_ct => score_ct, :score_t => score_t } }

      # L 05/10/2000 - 12:34:56: "Killer | Player<66><STEAM_ID_LAN><TERRORIST>" killed "Killed | Player<60><STEAM_ID_LAN><CT>" with "ak47"
      elsif @options[:display_kills] && data.gsub(/(\>" killed ")/).count > 0
        killer, killer_team, killed, killed_team, weapon = data.match(/"(.+)<\d+><STEAM_ID_LAN><(.+)>" killed "(.+)<\d+><STEAM_ID_LAN><(.+)>" with "(.+)"/i).captures
        content = { :type => 'kill', :params => { :killer_team => get_short_team_name(killer_team), :killer => killer, :killed_team => get_short_team_name(killed_team), :killed => killed, :weapon => weapon } }

      # L 05/10/2000 - 12:34:56: "Player<66><STEAM_ID_LAN><TERRORIST>" committed suicide with "worldspawn" (world)
      elsif @options[:display_kills] && data.gsub(/>" committed suicide/).count > 0
        killed = data.match(/: "(.+)<\d+>/).captures.first
        content = { :type => 'suicide', :params => { :killed => killed } }

      # L 05/10/2000 - 12:34:56: "Killer | Player<66><STEAM_ID_LAN><CT>" triggered "Defused_The_Bomb"
      elsif @options[:display_actions] && data.gsub(/<STEAM_ID_LAN><.+>" triggered "(.+)"$/).count > 0
        person, person_team, event = data.match(/: "(.+)<\d+><STEAM_ID_LAN><(.+)>" triggered "(.+)"/i).captures
        content = { :type => 'event', :params => { :person_team => get_short_team_name(person_team), :person => person, :event_item => event, :event_i18n => I18n.t(event.downcase)} }

      # L 05/10/2000 - 12:34:56: Loading map "de_dust2"
      elsif @options[:display_changelevel] && data.gsub(/: Loading map "(.+)"/).count > 0
        map = data.match(/: Loading map "(.+)"/i).captures.first
        content = { :type => 'loading_map', :params => { :map => map } }

      end

      if @options[:displayer].nil?; return(content) else @options[:displayer].new(content) end

    end

    # Format team name with long format (textual)
    #
    # @winner [String] Round winner (+CT+ or +T+) from logs
    #
    def get_full_team_name(winner)
      case winner
      when "T"
        return "#{I18n.t('full_team_name_te')}"
      else
        return "#{I18n.t('full_team_name_ct')}"
      end
    end

    # Format team name with short format (initials)
    #
    # @team [String] Round winner (+CT+ or +TERRORIST+) from logs
    #
    def get_short_team_name(team)
      case team
      when "TERRORIST"
        return "#{I18n.t('short_team_name_te')}"
      else
        return "#{I18n.t('short_team_name_ct')}"
      end
    end

  end
end