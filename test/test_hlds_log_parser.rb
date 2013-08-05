require "hlds_log_parser"
require "test/unit"
require "coveralls"
Coveralls.wear!

class HldsLogParserTest < Test::Unit::TestCase

  def test_default_locale
    assert_equal( :en, I18n.default_locale )    
  end

end
