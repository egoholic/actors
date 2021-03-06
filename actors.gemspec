# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'actors/version'

Gem::Specification.new do |spec|
  spec.name          = "actors"
  spec.version       = Actors::VERSION
  spec.authors       = ["Vladimir Melnik"]
  spec.email         = ["egotraumatic@gmail.com"]

  spec.summary       = %q{Actors is a simple library that provides an alternative to pub/sub and actors-model patterns.}
  spec.description   = %q{Actors is a simple library that provides an alternative to pub/sub and actors-model patterns. Actually Actors is a compromise between pub/sub and actors.}
  spec.homepage      = "http://itrampage.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "typed_map", "~> 0.1.0"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake",    "~> 10.0"
  spec.add_development_dependency "rspec",   "~> 3.0"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "mutant-rspec"
end
