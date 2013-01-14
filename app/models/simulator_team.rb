class SimulatorTeam < ActiveRecord::Base
  has_many :simulator_championship_participations
  has_many :simulator_championships, through: :simulator_championship_participations
  has_many :simulator_players

  def to_foot_stats
    {
      '@Id'     => self.source_id,
      '@Nome'   => self.full_name,
      '@Cidade' => self.city,
      '@Pais'   => self.country
    }
  end

  def self.to_foot_stats
    { 'Equipe' => all.map(&:to_foot_stats) }
  end

  def self.dump!
    SimulatorChampionship.all.each do |championship|
      FootStats::Team.all(championship: championship.source_id).each do |foot_stats_team|
        team = self.find_or_create_by_source_id foot_stats_team.source_id
        team.update_attributes foot_stats_team.attributes
        SimulatorChampionshipParticipation.find_or_create_by_simulator_team_id_and_simulator_championship_id team.id, championship.id
      end
    end
  end
end