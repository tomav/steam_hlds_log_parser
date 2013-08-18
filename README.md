# Steam HLDS Log Parser

##### Log parser for Steam HLDS based games like Counter-Strike

Steam Hlds Log Parser listens to UDP log packets sent by your _(local or remote)_ HLDS game server, processes data and returns clean and  readable (translated) content that you can use for your website, irc channel, match live streaming, bots, database...

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

And in your Ruby file:

    require "steam_hlds_log_parser"

## Full working example

By default, Steam HLDS Log Parser runs on `0.0.0.0:27115` _(+100 than default HLDS port which is 27015)_  

1 - On your game server, send logs to your Ruby server (in this example, same machine).

```
logaddress 0.0.0.0 27115
``` 

or  

```
logaddress_add 0.0.0.0 27115
```

2 - Create a file named, for example, `hlds_parser.rb` with this content:

```ruby
require "rubygems"
require "steam_hlds_log_parser"

# Your displayer Class is what you will do with your data
class Formatter
  def initialize(data)
    # will 'puts' the translated content, using built-in Displayer
    SteamHldsLogParser::Displayer.new(data).display_translation
  end
end

# Setup the Client to use the 'Formatter' Class as displayer callback
# Options will be use default values (see example-2.rb)
SteamHldsLogParser::Client.new(Formatter).start
```

3 - Now, run the Ruby script to see parsed content inyour console:

```
ruby hlds_parser.rb
```

Your game server activity should look something like that:

```
[T] Jim_Carrey spawned with the bomb
[CT] Tomav says "Com'on guys!"
[CT] V0id killed [T] killaruna with deagle
[T] Funky Byte killed [CT] Neuromancer with m4a1
[CT] Tomav killed [T] Funky Byte with deagle
[T] Juliet_Lewis killed [CT] Make my Day with ak47
[CT] Alloc killed [T] Juliet_Lewis with famas
[T] Jim_Carrey planted the bomb
[CT] Tomav killed [T] Jim_Carrey with sg552
[CT] Tomav begin bomb defuse with kit
[CT] Jim_Carrey says "aaaaaargh!!!" to others [T]
[CT] Tomav defused the bomb
[CT] 1 - 6 [T]
Map ends: CT => 1
Map ends: T => 6
Loading de_dust2
```

Now customize your Formatter class to make it fit your needs.

## Documentation

Steam HLDS Log Parser should be 100% documented.
However, if you find something to improve, feel free to contribute.
Full documentation can be found on [Steam HLDS Parser Log page on Rubydoc](http://rubydoc.info/gems/steam_hlds_log_parser).

## Tests

Steam HLDS Log Parser uses RSpec as test / specification framework and should be 100% tested too.
Here again, feel free to improve it.

## FAQ

### What do I need to use this gem?

* Ruby 1.9+
* Basic Ruby skill
* Steam HLDS Server with SSH access or RCON password

### My Client is running, but nothing appears in my console?!
Common issues are:

* HLDS with no or miconfigured `logaddress`
* Firewall not properly configured (remember that HLDS sends `UDP` packets, not `TCP`)
* Have a look to your Displayer Class

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
