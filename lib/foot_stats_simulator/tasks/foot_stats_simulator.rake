namespace :foot_stats do
  namespace :clone do
    desc "Clones FootStats championships to database"
    task championship: :environment do
      base_url = FootStats::Setup.base_url
      FootStats::Setup.base_url = "http://footstats.com.br/modyo.asmx/"
      SimulatorChampionship.dump!
      FootStats::Setup.base_url = base_url
    end

    desc "Clones FootStats championship teams to database"
    task team: :environment do
      base_url = FootStats::Setup.base_url
      FootStats::Setup.base_url = "http://footstats.com.br/modyo.asmx/"
      SimulatorTeam.dump!
      FootStats::Setup.base_url = base_url
    end

    desc "Clones FootStats players to database"
    task player: :environment do
      base_url = FootStats::Setup.base_url
      FootStats::Setup.base_url = "http://footstats.com.br/modyo.asmx/"
      SimulatorPlayer.dump!
      FootStats::Setup.base_url = base_url
    end

    desc "Clones all FootStats data to database"
    task data: :environment do
      base_url = FootStats::Setup.base_url
      FootStats::Setup.base_url = "http://footstats.com.br/modyo.asmx/"
      SimulatorChampionship.dump!
      SimulatorTeam.dump!
      SimulatorPlayer.dump!
      FootStats::Setup.base_url = base_url
    end
  end

  desc "Setups all foot stats related content and create it's tables"
  task bootstrap: :environment do
    Rake::Task["foot_stats:migrate"].execute
    Rake::Task["foot_stats:clone:data"].execute
  end

  desc "Deletes all FootStats simulator data stored on database"
  task clean: :environment do
    SimulatorChampionship.delete_all
    SimulatorTeam.delete_all
    SimulatorPlayer.delete_all
  end

  desc "Migrate simulator data"
  task migrate: :environment do
    load 'foot_stats_simulator/migrate.rb'
  end
end