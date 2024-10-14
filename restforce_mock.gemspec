# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'restforce_mock/version'

Gem::Specification.new do |spec|
  spec.name          = "restforce_mock"
  spec.version       = RestforceMock::VERSION
  spec.authors       = ["Ilya Katz"]
  spec.email         = ["ilyakatz@gmail.com"]

  spec.summary       = %q{Mock for Restforce gem}
  spec.description   = %q{Mock for Restforce gem}
  spec.homepage      = "https://github.com/ilyakatz/restforce_mock"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "restforce"
  spec.add_development_dependency "bundler", "~> 2.2"
  spec.add_development_dependency "rake", "~> 12.3.3"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "dotenv"
end
