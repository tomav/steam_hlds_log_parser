# HldsLogParser

Creates a server with EventMachine which listens to HLDS logs, parse and returns readable content from your game server.
The returned content can be sent to a website, IRC or flowdock for match live streaming.

Note : content is sent in english or french at this time. Need i18n contributors!

## Installation

Add this line to your application's Gemfile:

    gem 'hlds_log_parser'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hlds_log_parser

## Usage

1. Create a `class` called `HldsDisplayer` which will receive parsed data.  
Ask this `class` to write a file, send to IRC or flowdock... whatever...
2. Create a new client on desired IP / Port
3. In your HLDS server: `logaddress 127.0.0.1 27035`  

## Example

    require "rubygems"
    require "hlds_log_parser"

    ## These are default options
    options = {
      :locale              => :en,
      :display_kills       => true,
      :display_actions     => true,
      :display_changelevel => true,
      # Except this one, but you will probably use your own Displayer
      # This on will puts content to console
      :displayer           => HldsLogParser::HldsPutsDisplayer
    }

    parser = HldsLogParser::Client.new("127.0.0.1", 27035, options)
    parser.connect



## TODO

* JSON responder to allow user to make their own formatter / store in database

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
