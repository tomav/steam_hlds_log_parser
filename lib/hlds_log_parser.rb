require "rubygems"
require "eventmachine"
require "i18n"
require "rdoc"

require "hlds_log_parser/version"
require "hlds_log_parser/client"
require "hlds_log_parser/handler"
require "hlds_log_parser/displayers"

module HldsLogParser

  I18n.load_path = Dir.glob( File.dirname(__FILE__) + "/locales/*.yml" )
  I18n.default_locale = :en

end




