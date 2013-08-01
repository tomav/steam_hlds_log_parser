require "hlds_log_parser"
require "test/unit"

class ClientTest < Test::Unit::TestCase

  # Helpers

  def default_client
    options = { :test => true }
    return HldsLogParser::Client.new("0.0.0.0", 27035, options)
  end

  def custom_client
    options = {
      :locale              => :fr,
      :display_kills       => false,
      :display_actions     => false,
      :display_changelevel => false,
      :test                => true
    }
    return HldsLogParser::Client.new("0.0.0.0", 27035, options)
  end

  # Tests
  
  def test_options_is_a_hash
    assert_equal( Hash , default_client.options.class )
  end

  def test_default_locale_if_unset
    assert_equal( :en , default_client.options[:locale] )
  end

  def test_custom_locale
    assert_equal( :fr , custom_client.options[:locale] )
  end

  def test_custom_display_kills
    assert_equal( false , custom_client.options[:display_kills] )
  end

  def test_custom_display_actions
    assert_equal( false , custom_client.options[:display_actions] )
  end

  def test_custom_display_changelevel
    assert_equal( false , custom_client.options[:display_changelevel] )
  end

end