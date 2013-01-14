# TODO: Handle penalties

class SimulatorTimeline
  attr_reader :match

  attr_accessor :states, :current_period, :current_minute
  attr_accessor :narration, :home_goals, :home_cards, :current_home_players, :visitor_goals, :visitor_cards, :current_visitor_players

  def initialize(match, timeline_name)
    @match         = match
    @timeline_path = File.expand_path File.join(FootStatsSimulator.timelines_dir, "#{timeline_name}.rb")
    load_timeline
  end

  def timeline_rand(limit = nil)
    @random.rand limit
  end

  def sample(collection)
    collection[timeline_rand(collection.size)]
  end

  def collection_of(n, collection)
    collecteds = []
    while collecteds.size < n
      collected = sample(collection)
      collecteds << collected unless collecteds.include?(collected)
    end
    collecteds
  end

  def home_score
    home_goals.count{ |g| g.type == 'Favor' } + visitor_goals.count{ |g| g.type != 'Favor' }
  end

  def visitor_score
    visitor_goals.count{ |g| g.type == 'Favor' } + home_goals.count{ |g| g.type != 'Favor' }
  end

  def home_team
    @match.home_team
  end

  def visitor_team
    @match.visitor_team
  end

  def home_players
    @home_players ||= @match.home_simulator_team.simulator_players.order(:source_id)
  end

  def visitor_players
    @visitor_players ||= @match.visitor_simulator_team.simulator_players.order(:source_id)
  end

  def all_current_players
    current_home_players + current_visitor_players
  end

  def all_players
    home_players + visitor_players
  end

  def update_match
    @match.update_attributes status:                    current_period,
                             home_score:                home_score,
                             home_penalties_score:      nil,
                             visitor_score:             visitor_score,
                             visitor_penalties_score:   nil
  end

  def transitions(&block)
    States.new(self, &block)
  end

  def period(period)
    if block_given?
      yield Period.new(self, period)
    else
      Period.new(self, period_time)
    end
  end

  def current_period_time
    SimulatorMatch::STATUS_SEQUENCE[current_period] || current_period.to_i
  end

  protected
  def load_timeline
    @random = Random.new @match.timeline_random_seed

    @states                  = []
    @narration               = []
    @home_goals              = []
    @home_cards              = []
    @current_home_players    = []
    @visitor_goals           = []
    @visitor_cards           = []
    @current_visitor_players = []

    eval File.read(@timeline_path)
  end
end