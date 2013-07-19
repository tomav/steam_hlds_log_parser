# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hlds_log_parser/version'

Gem::Specification.new do |spec|
  spec.name          = "hlds_log_parser"
  spec.version       = HldsLogParser::VERSION
  spec.authors       = ["Thomas VIAL"]
  spec.email         = ["github@ifusio.com"]
  spec.description   = %q{HLDS Client to parse game server log file}
  spec.summary       = %q{HLDS Client to parse game server log file}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end