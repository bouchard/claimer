# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'claimer/version'

Gem::Specification.new do |spec|
  spec.name          = "claimer"
  spec.version       = Claimer::VERSION
  spec.authors       = ["Brady Bouchard"]
  spec.email         = ["brady@thewellinspired.com"]
  spec.summary       = %q{Ruby library for automated claim submissions to Canadian Provincial Medical Service Branches.}
  spec.homepage      = "https://github.com/bouchard/claimer"
  spec.license       = "MIT"
  spec.date          = Date.today.to_s

  spec.files         = Dir['Rakefile', '{bin,lib,man,test,spec}/**/*', 'README*', 'LICENSE*'] & `git ls-files -z`.split("\0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
