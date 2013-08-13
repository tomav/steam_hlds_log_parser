# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'steam_hlds_log_parser/version'

Gem::Specification.new do |spec|
  spec.name          = "steam_hlds_log_parser"
  spec.version       = SteamHldsLogParser::VERSION
  spec.authors       = ["Thomas VIAL"]
  spec.email         = ["github@ifusio.com"]
  spec.description   = %q{Steam HLDS Log Parser receives logs from your Steam game server and parses them in real time to give you usable content for your website, irc channel / flowdock... Works well with Counter-Strike and others Half-life based games.}
  spec.summary       = %q{Steam HLDS Log Parser receives logs from your Steam game server and parses them in real time to give you usable content for your website, irc channel / flowdock... Works well with Counter-Strike and others Half-life based games.}
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
