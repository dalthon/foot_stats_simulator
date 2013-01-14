class SimulatorTimeline
  class GoalEvent < SimulatorTimeline::Event
    attr_reader :player, :type, :reference

    def initialize(event_handler, timeline, period_time, minute, options = {})
      @player, @type, @reference = options.values_at :player, :type, :reference
      @type ||= 'Favor'
      super(event_handler, timeline, period_time, minute, options)
    end

    def to_foot_stats
      {
        "@Jogador" => @player.full_name,
        "@Periodo" => SimulatorMatch::STATUS_MAP[SimulatorMatch::STATUSES[@period_time]],
        "@Minuto"  => @minute.to_s,
        "@Tipo"    => @type
      }
    end

    def self.remove(timeline, reference)
      timeline.home_goals.delete_if{ |event| event.reference == reference }
      timeline.visitor_goals.delete_if{ |event| event.reference == reference }
    end

    def self.to_foot_stats(array_of_goals)
      fuck_collection 'Gol', array_of_goals.map(&:to_foot_stats)
    end

    protected
    def apply_event
      if @player.simulator_team == @timeline.home_team
        @timeline.home_goals << self
      else
        @timeline.visitor_goals << self
      end

      event_handler.narration :goal, current_player: @player.nickname, player_team: @player.simulator_team.full_name
    end
  end
end