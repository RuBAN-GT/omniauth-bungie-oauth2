# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth-bungie-oauth2/version'

Gem::Specification.new do |spec|
  spec.name          = 'omniauth-bungie-oauth2'
  spec.version       = OmniAuth::BungieOauth2::VERSION
  spec.authors       = ['Dmitry Ruban']
  spec.email         = ['dkruban@gmail.com']

  spec.summary       = %q{A Bungie OAuth2 strategy for Omniauth}
  spec.description   = %q{A Bungie OAuth2 strategy for Omniauth}
  spec.homepage      = 'https://github.com/RuBAN-GT/omniauth-bungie-oauth2'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split("\n")
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.add_runtime_dependency 'omniauth-oauth2', '~> 1.4', '>= 1.4.0'
end
