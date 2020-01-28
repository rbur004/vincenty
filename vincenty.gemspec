# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vincenty'

Gem::Specification.new do |spec|
  spec.name          = "vincenty"
  spec.description   = File.read('README.md', :encoding => "utf-8").delete("\r").split(/\n\n+/).values_at(1..4).join("\n\n")
  spec.version       = Vincenty::VERSION
  spec.licenses      = ['Ruby']
  spec.authors       = ['Rob Burrowes']
  spec.email         = ['r.burrowes@auckland.ac.nz']

  spec.summary       = "Vincenty Algorithm for Distance, Bearing between Map Coordinates."
  spec.homepage      = "http://rbur004.github.io/vincenty/"

  spec.files         =  File.readlines("Manifest.txt")
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.9.2'

  spec.add_development_dependency 'yard', '~> 0.9'
  spec.add_development_dependency 'minitest', '~> 5.8', '>= 0'
end
