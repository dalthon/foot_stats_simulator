require 'foot_stats_simulator/engine'
require 'foot_stats'

require 'faker'

require 'singleton'

class FootStatsSimulator
  attr_accessor :timelines_dir

  include Singleton

  def self.method_missing(method_name, *args, &block)
    instance.send method_name, *args, &block
  end
end
