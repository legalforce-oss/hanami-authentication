# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "hanami/authentication/version"

Gem::Specification.new do |spec|
  spec.name          = 'hanami-authentication'
  spec.version       = Hanami::Authentication::VERSION
  spec.authors       = ['LegalForce Inc.']
  spec.email         = ['info@legalforce.co.jp']

  spec.summary       = 'A simple authentication module for hanami.'
  spec.description   = 'A simple authentication module for hanami.'
  spec.homepage      = 'https://github.com/legalforce/hanami-authentication'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'bcrypt', '~> 3.1'

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
