module FootStatsSimulator
  class Engine < ::Rails::Engine
    isolate_namespace FootStatsSimulator

    rake_tasks do
      load 'foot_stats_simulator/tasks/foot_stats_simulator.rake'
    end
  end
end
