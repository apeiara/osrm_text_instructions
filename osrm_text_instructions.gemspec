# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'osrm_text_instructions/version'

Gem::Specification.new do |spec|
  spec.name          = 'osrm_text_instructions'
  spec.version       = OSRMTextInstructions::VERSION
  spec.authors       = ['Felipe Zavan']
  spec.email         = ['felipe@zavan.me']

  spec.summary       = %q{A gem to transform OSRM steps into text instructions.}
  spec.homepage      = 'https://github.com/zavan/osrm_text_instructions'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
end
