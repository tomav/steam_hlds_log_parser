require "hlds_log_parser"
require "test/unit"

class HldsLogParserTest < Test::Unit::TestCase

  def test_default_locale
    assert_equal( :en, I18n.default_locale )    
  end

end
