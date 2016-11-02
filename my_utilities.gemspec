# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'my_utilities/version'

Gem::Specification.new do |spec|
  spec.name          = "my_utilities"
  spec.version       = MyUtilities::VERSION
  spec.authors       = ["Sameer Siruguri"]
  spec.email         = ["sameers.public@gmail.com"]
  spec.description   = %q{Some common utilities I've created for my Ruby work}
  spec.summary       = %q{These functions do a bunch of cool things, like log error messages, find a parent folder with a specific file in it, and so on.} 
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  if !(RUBY_VERSION =~ /^2.1/)
    spec.add_dependency 'getopt', "~>1.3"
  end 

  spec.add_development_dependency "bundler", "~>1.13"
  spec.add_development_dependency 'rspec', "~>3.5"  
  spec.add_development_dependency "rake", "~>11.3"
end
