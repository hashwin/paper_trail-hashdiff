# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'paper_trail_hashdiff'
  s.version     = '0.0.1'
  s.date        = '2018-06-01'
  s.summary     = 'Paper Trail Hashdiff'
  s.description = 'Allows storing only incremental changes in the object_changes column'
  s.authors     = ['Ashwin Hegde']
  s.email       = 'ashwin.hegde12@gmail.com'
  s.files       = ['lib/paper_trail_hashdiff.rb']
  s.homepage    = 'https://github.com/hashwin/paper_trail_hashdiff'
  s.license = 'MIT'

  s.add_runtime_dependency 'hashdiff'
  s.add_development_dependency 'rubocop'
end
