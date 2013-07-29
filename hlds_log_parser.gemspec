# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hlds_log_parser/version'

Gem::Specification.new do |spec|
  spec.name          = "hlds_log_parser"
  spec.version       = HldsLogParser::VERSION
  spec.authors       = ["Thomas VIAL"]
  spec.email         = ["github@ifusio.com"]
  spec.description   = %q{HLDS Log Parser receives logs from your game server and parse them in real time to give you usable content for your website, irc channel / flowdock...}
  spec.summary       = %q{HLDS Log Parser receives logs from your game server and parse them in real time to give you usable content for your website, irc channel / flowdock...}
  spec.homepage      = "https://github.com/tomav/hlds_log_parser"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "bundler", "~> 1.3"
  spec.add_dependency "rake"
  spec.add_dependency "eventmachine", "~> 1.0.3"
  spec.add_dependency "i18n"
end