module HldsLogParser

  class Handler < EM::Connection

    # Initialize Handler from Client options
    def initialize(host, port, options)
      @host, @port, @options = host, port, options
    end

    def post_init
      puts "## #{@host}:#{@port} => #{I18n.t('client_connect')}" unless @options[:test]
    end

    def unbind
      puts "## #{@host}:#{@port} => #{I18n.t('client_disconnect')}" unless @options[:test]
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
    # ==== Attributes
    #
    # * +data+ - Data received by Client from HLDS server (a line of log)
    #
    def receive_data(data)

      # L 05/10/2000 - 12:34:56: Team "CT" scored "17" with "0" players
      if data.gsub(/Team "(.+)" scored "(\d+)" with "(\d+)"/).count > 0
        winner, winner_score = data.match(/Team "(.+)" scored "(\d+)" with/).captures
        content = "#{I18n.t('map_ends', :winner => get_short_team_name(winner), :score => winner_score)}"

      # L 05/10/2000 - 12:34:56: Team "CT" triggered "CTs_Win" (CT "3") (T "0")
      elsif data.gsub(/(: Team ")/).count > 0
        winner, type, score_ct, score_t = data.match(/Team "([A-Z]+)" triggered "([A-Za-z_]+)" \(CT "(\d+)"\) \(T "(\d+)"\)/i).captures
        content = "[CT] #{score_ct} - #{score_t} [TE] => #{I18n.t(type.downcase)}"

      # L 05/10/2000 - 12:34:56: "Killer | Player<66><STEAM_ID_LAN><TERRORIST>" killed "Killed | Player<60><STEAM_ID_LAN><CT>" with "ak47"
      elsif @options[:display_kills] && data.gsub(/(\>" killed ")/).count > 0
        killer, killer_team, killed, killed_team, weapon = data.match(/"(.+)<\d+><STEAM_ID_LAN><(.+)>" killed "(.+)<\d+><STEAM_ID_LAN><(.+)>" with "(.+)"/i).captures
        content = "[#{get_short_team_name(killer_team)}] #{killer} #{I18n.t('killed')} [#{get_short_team_name(killed_team)}] #{killed} #{I18n.t('with')} #{weapon}"

      # L 05/10/2000 - 12:34:56: "Player<66><STEAM_ID_LAN><TERRORIST>" committed suicide with "worldspawn" (world)
      elsif @options[:display_kills] && data.gsub(/>" committed suicide/).count > 0
        killed = data.match(/: "(.+)<\d+>/).captures.first
        content = "#{killed} #{I18n.t('committed_suicide')}"

      # L 05/10/2000 - 12:34:56: "Killer | Player<66><STEAM_ID_LAN><CT>" triggered "Defused_The_Bomb"
      elsif @options[:display_actions] && data.gsub(/<STEAM_ID_LAN><.+>" triggered "(.+)"$/).count > 0
        person, person_team, type = data.match(/: "(.+)<\d+><STEAM_ID_LAN><(.+)>" triggered "(.+)"/i).captures
        content = "[#{get_short_team_name(person_team)}] #{person} #{I18n.t(type.downcase)}"

      # L 05/10/2000 - 12:34:56: Loading map "de_dust2"
      elsif @options[:display_changelevel] && data.gsub(/: Loading map "(.+)"/).count > 0
        map = data.match(/: Loading map "(.+)"/i).captures.first
        content = "#{I18n.t('loading_map', :map => map)}"

      end

      if @options[:displayer].nil?; return(content) else @options[:displayer].new(content) end

    end

    # Format team name with long format (textual)
    #
    # ==== Attributes
    #
    # * +winner+ - Round winner (+CT+ or +T+) from logs
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
    # ==== Attributes
    #
    # * +team+ - Round winner (+CT+ or +TERRORIST+) from logs
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