require 'rubygems' 
Gem::manage_gems
require 'rake/gempackagetask'

spec = Gem::Specification.new do |s| 
  s.name = "Vincenty" 
  s.version = "1.0.1" 
  s.author = "Rob Burrowes" 
  s.email = "r.burrowes@burrowes" 
  s.homepage = "http://rubyforge.org/projects/vincenty/" 
  s.platform = Gem::Platform::RUBY 
  s.summary = "Vincenty Algorithm for Distance, Bearing between Map Coordinates." 
  s.files = FileList["{bin,docs,lib,test}/**/*"].exclude("rdoc").to_a
  s.require_path = "lib" 
  s.autorequire = "vincenty" 
  s.test_file = "test/ts_all.rb" 
  s.has_rdoc = true 
  s.extra_rdoc_files = ["README"] 
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar = true
end
