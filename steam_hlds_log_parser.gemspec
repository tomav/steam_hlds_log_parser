# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'steam_hlds_log_parser/version'

Gem::Specification.new do |spec|
  spec.name          = "steam_hlds_log_parser"
  spec.version       = SteamHldsLogParser::VERSION
  spec.authors       = ["Thomas VIAL"]
  spec.email         = ["github@ifusio.com"]
  spec.description   = %q{Steam Hlds Log Parser listens to UDP log packets sent by your (local or remote) HLDS game server, processes data and returns clean or/and translated and readable content that you can use for your website, irc channel, match live streaming, bots, database... Should work with all Steam HLDS based games, and has been mostly tested on Counter-Strike 1.6.}
  spec.summary       = %q{Steam Hlds Log Parser listens to UDP log packets sent by your (local or remote) HLDS game server, processes data and returns clean or/and translated and readable content that you can use for your website, irc channel, match live streaming, bots, database... Should work with all Steam HLDS based games, and has been mostly tested on Counter-Strike 1.6.}
  spec.homepage      = "https://github.com/tomav/steam_hlds_log_parser"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "bundler", "~> 1.3"
  spec.add_dependency "rake"
  spec.add_dependency "eventmachine", "~> 1.0.3"
  spec.add_dependency "i18n"

  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "rspec-core"
  spec.add_development_dependency "rspec"

end
