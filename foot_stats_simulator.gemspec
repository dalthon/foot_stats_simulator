$:.push File.expand_path('../lib', __FILE__)

require 'foot_stats_simulator/version'

Gem::Specification.new do |s|
  s.name        = 'foot_stats_simulator'
  s.version     = FootStatsSimulator::VERSION
  s.authors     = ['Dalton Pinto']
  s.email       = ['dalton.pinto@codeminer42.com']
  s.homepage    = 'http://codeminer42.com'
  s.summary     = 'Simulator that aims to emulate FootStats service'
  s.description = 'Simulator that aims to emulate FootStats service'

  s.files      = Dir['{app,config,db,lib}/**/*'] + ['MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '~> 3.2.9'
  s.add_dependency 'foot_stats'
  s.add_dependency 'faker'

  s.add_development_dependency 'sqlite3'
end
