require 'foot_stats_simulator/engine'
require 'foot_stats'

require 'faker'

module FootStatsSimulator
  def self.timelines_dir
    File.join Rails.root, 'tmp/timelines'
  end
end
