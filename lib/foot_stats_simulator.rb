require 'foot_stats_simulator/engine'
require 'foot_stats'

require 'faker'

module FootStatsSimulator
  def self.timelines_dir=(path)
    @timelines_dir = path
  end

  def self.timelines_dir
    @timelines_dir
  end
end
