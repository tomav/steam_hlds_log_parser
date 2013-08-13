# Steam Hlds Log Parser

Steam Hlds Log Parser listens to UDP log packets sent by your (local or remote) HLDS game server, processes data and returns clean or/and translated and readable content that you can use for your website, irc channel, match live streaming, bots, database...

Should work with all Steam HLDS based games, and has been mostly tested on Counter-Strike 1.6.

Note : translated content is sent in english or french at this time. Need i18n contributors!

## Build Status

[![Build Status](https://travis-ci.org/tomav/steam_hlds_log_parser.png?branch=master)](https://travis-ci.org/tomav/steam_hlds_log_parser)
[![Gem Version](https://badge.fury.io/rb/steam_hlds_log_parser.png)](http://badge.fury.io/rb/steam_hlds_log_parser)
[![Coverage Status](https://coveralls.io/repos/tomav/steam_hlds_log_parser/badge.png)](https://coveralls.io/r/tomav/steam_hlds_log_parser)

## Installation

Add this line to your application's Gemfile:

    gem 'steam_hlds_log_parser'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install steam_hlds_log_parser

## Configuration

1. Create your own displayer callback `class` which will receive parsed data
Ask this `class` to write a file, send content to IRC or flowdock... whatever... and give it as `:displayer` Hash option
2. Create a new client on desired IP / Port / Options
3. Of course, you need to have server RCON. In your `server.cfg` (or in server console) add `logaddress 127.0.0.1 27035`. It specifies where the logs will be sent. This must be the IP / Port your ruby client will listen to.

If you are behind a router/firewall, you probably need to configure it.

## Example

    require "rubygems"
    require "steam_hlds_log_parser"

    class Formatter
      def initialize(data)
        # will 'puts' the translated content
        SteamHldsLogParser::Displayer.new(data).display_translation
      end
    end


    ## These are default options
    options = {
      :locale              => :en,
      :display_kills       => true,
      :display_actions     => true,
      :display_changelevel => true,
      :displayer           => Formatter
    }

    parser = SteamHldsLogParser::Client.new("127.0.0.1", 27035, options)
    parser.start

## Documentation

Steam HLDS Log Parser should be 100% documented.
However, if you find something to improve, feel free to contribute.
Full documentation can be found on [Steam HLDS Parser Log page on Rubydoc](http://rubydoc.info/gems/steam_hlds_log_parser).

## Tests

Steam HLDS Log Parser uses RSpec as test / specification framework and should be 100% tested too.
Here again, feel free to improve it.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
