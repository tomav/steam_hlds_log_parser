# HldsLogParser

Creates a server with EventMachine which listens to HLDS logs, parse and returns readable content from your game server.
The returned content can be sent to a website, IRC or flowdock for match live streaming.

Mostly tested on Steam HLDS for Counter-Strike.

Note : content is sent in english or french at this time. Need i18n contributors!

## Build Status

[![Build Status](https://travis-ci.org/tomav/hlds_log_parser.png?branch=master)](https://travis-ci.org/tomav/hlds_log_parser)
[![Gem Version](https://badge.fury.io/rb/hlds_log_parser.png)](http://badge.fury.io/rb/hlds_log_parser)
[![Coverage Status](https://coveralls.io/repos/tomav/hlds_log_parser/badge.png)](https://coveralls.io/r/tomav/hlds_log_parser)

## Installation

Add this line to your application's Gemfile:

    gem 'hlds_log_parser'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hlds_log_parser

## Usage

1. Create your own displayer callback `class` which will receive parsed data
Ask this `class` to write a file, send content to IRC or flowdock... whatever... and give it as `:displayer` Hash option
2. Create a new client on desired IP / Port / Options
3. In your HLDS server: `logaddress 127.0.0.1 27035`  

## Example

    require "rubygems"
    require "hlds_log_parser"

    class Formatter
      def initialize(data)
        # will 'puts' the translated content
        HldsLogParser::HldsDisplayer.new(data).display_translation
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

    parser = HldsLogParser::Client.new("127.0.0.1", 27035, options)
    parser.start


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
