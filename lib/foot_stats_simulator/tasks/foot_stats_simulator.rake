namespace :foot_stats do
  namespace :clone do
    desc "Clones FootStats championships to database"
    task championship: :environment do
      SimulatorChampionship.dump!
    end

    desc "Clones FootStats championship teams to database"
    task team: :environment do
      SimulatorTeam.dump!
    end

    desc "Clones FootStats players to database"
    task player: :environment do
      SimulatorPlayer.dump!
    end

    desc "Clones all FootStats data to database"
    task data: :environment do
      SimulatorChampionship.dump!
      SimulatorTeam.dump!
      SimulatorPlayer.dump!
    end
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