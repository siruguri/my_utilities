# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'my_utilities/version'

Gem::Specification.new do |spec|
  spec.name          = "my_utilities"
  spec.version       = MyUtilities::VERSION
  spec.authors       = ["Sameer Siruguri"]
  spec.email         = ["siruguri@gmail.com"]
  spec.description   = %q{Some common utilities I've created for my Ruby work}
  spec.summary       = %q{These functions do a bunch of cool things, like log error messages, find a parent folder with a specific file in it, and so on.} 
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency 'minitest'  
  spec.add_development_dependency "rake"
end
