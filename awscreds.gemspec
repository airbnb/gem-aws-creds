# coding: utf-8
lib = File.expand_path '../lib', __FILE__
$LOAD_PATH.unshift lib unless $LOAD_PATH.include? lib

require 'awscreds/version'

Gem::Specification.new do |spec|
  spec.name          = 'awscreds'
  spec.version       = AWSCreds::VERSION
  spec.authors       = ['Pierre Carrier']
  spec.email         = ['pierre@gcarrier.fr']
  spec.description   = 'AWS credentials manager'
  spec.summary       = 'AWSCreds exposes your AWS credentials through the command line or Ruby API'
  spec.homepage      = 'https://github.com/airbnb/awscreds'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split $/
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename f }
  spec.test_files    = spec.files.grep %r{^(test|spec|features)/}
  spec.require_paths = %w[lib]

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'

  spec.add_dependency 'trollop', '~> 2.0'
end
