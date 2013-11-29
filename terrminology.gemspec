# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'terrminology/version'

Gem::Specification.new do |spec|
  spec.name          = 'Terrminology'
  spec.version       = Terrminology::VERSION
  spec.authors       = ['dmitry-n']
  spec.email         = ['nechayevdv@gmail.com']
  spec.description   = %q{FHIR value sets}
  spec.summary       = %q{FHIR value sets}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'pg'
  spec.add_dependency 'sequel'
  spec.add_dependency 'virtus'
  spec.add_dependency 'uuid'

  spec.add_development_dependency 'bundler', "~> 1.3"
  spec.add_development_dependency 'rake'
end
