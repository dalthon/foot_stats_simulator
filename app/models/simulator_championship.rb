class SimulatorChampionship < ActiveRecord::Base
  has_many :simulator_championship_participations
  has_many :simulator_teams, through: :simulator_championship_participations
  has_many :simulator_matches

  def classification
    @classification ||= SimulatorClassification.new(self)
  end

  def to_foot_stats
    {
      '@Id'               => self.source_id.to_s,
      '@Nome'             => self.name,
      '@TemClassificacao' => (self.has_classification ? 'True' : 'False'),
      '@RodadaATual'      => self.current_round.to_s,
      '@Rodadas'          => self.total_rounds.to_s
    }
  end

  def self.to_foot_stats
    { 'Campeonato' => all.map(&:to_foot_stats) }
  end

  def self.dump!
    FootStats::Championship.all.each do |foot_stats_championship|
      championship = self.find_or_create_by_source_id foot_stats_championship.source_id
      championship.update_attributes foot_stats_championship.attributes
    end
  end
end