require "hlds_log_parser/version"
require "eventmachine"
require "rdoc"

module HldsLogParser

  class Client

    attr_accessor :s

    # Creates a new client which will receive HLDS logs (using UDP)
    #
    # ==== Attributes
    #
    # * +host+ - Hostname / IP Address the server will be running
    # * +port+ - Port to listen to
    def initialize(host, port)
      EM.run {
        @@s = EM::open_datagram_socket(host, port, Handler)
        puts "=> Client is now listening on #{host}:#{port} waiting for HLDS logs"
      }
     end

    public 

    # Stops the running client
    def stop
      @@s.close_connection
      puts "=> Client is now stopped."
    end
  end

  class Handler < EM::Connection
    # Get data from Client and parse using Regexp
    #
    # * match the end of round, with score and victory type
    # * match who killed who with what
    #
    # ==== Attributes
    #
    # * +data+ - Data received by Client from HLDS server (a line of log)
    def receive_data(data)
      if data.gsub(/(: Team ")/).count > 0
        # L 05/10/2000 - 12:34:56: Team "CT" triggered "CTs_Win" (CT "3") (T "0")
        winner, type, score_ct, score_t = data.match(/Team "([A-Z]+)" triggered "([A-Za-z_]+)" \(CT "(\d+)"\) \(T "(\d+)"\)/i).captures
        HldsDisplayer.new("[CT] #{score_ct} - #{score_t} [TE] => Victoire des #{get_winner(winner)} par #{get_type(type)}")
      elsif data.gsub(/(\>" killed ")/).count > 0
        # L 05/10/2000 - 12:34:56: "Killer | Player<66><STEAM_ID_LAN><TERRORIST>" killed "Killed | Player<60><STEAM_ID_LAN><CT>" with "ak47"
        killer, killer_id, killer_team, killed, killed_id, killed_team, weapon = data.match(/: "(.+)<(\d+)><STEAM_ID_LAN><([A-Z]+)>" killed "(.+)<(\d+)><STEAM_ID_LAN><([A-Z]+)>" with "([A-Za-z0-9_]+)/i).captures
        HldsDisplayer.new("[#{killer_team}] #{killer} killed [#{killed_team}] #{killed} with #{weapon}")
      end
    end

    # Format the winner team name
    #
    # ==== Attributes
    #
    # * +winner+ - Round winner (+CT+ or +T+) from logs
    def get_winner(winner)
      case winner
      when "T"
        return "Terroristes"
      else
        return "Anti-Terroristes"
      end
    end

    # Format the type of victory
    #
    # ==== Attributes
    #
    # * +type+ - Victory type from logs (+Target_Saved+, +Target_Bombed+...)
    def get_type(type)
      case type
      when "Bomb_Defused"
        return "desamorcage de la bombe"
      when "Target_Bombed"
        return "destruction du site"
      when "Target_Saved"
        return "protection du site"
      else
        return "elimination de l'equipe adverse"
      end
    end

  end

end




