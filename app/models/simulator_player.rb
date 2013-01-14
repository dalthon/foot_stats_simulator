class SimulatorPlayer < ActiveRecord::Base
  belongs_to :simulator_team

  def to_foot_stats
    {
      '@Id'      => self.source_id,
      '@Nome'    => self.full_name,
      '@Apelido' => self.nickname
    }
  end

  def self.to_foot_stats
    # FootStats suck!
    # Yes, it's stupid, but it's true...
    # FootStats doesn't return a collection on this...
    if count == 0
      nil
    else
      if count == 1
        self.first.to_foot_stats
      else
        { 'Equipe' => all.map(&:to_foot_stats) }
      end
    end
  end

  def self.dump!
    SimulatorTeam.all.each do |team|
      FootStats::Player.all(team: team.source_id).each do |foot_stats_player|
        player = self.find_or_create_by_source_id foot_stats_player.source_id
        player.update_attributes foot_stats_player.attributes.merge(simulator_team_id: team.id)
      end
    end
  end
end