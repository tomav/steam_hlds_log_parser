require "rubygems"
require "eventmachine"
require "i18n"
require "rdoc"

require "steam_hlds_log_parser/version"
require "steam_hlds_log_parser/client"
require "steam_hlds_log_parser/handler"
require "steam_hlds_log_parser/displayer"

module SteamHldsLogParser

  I18n.load_path = Dir.glob( File.dirname(__FILE__) + "/locales/*.yml" )
  I18n.default_locale = :en

end
