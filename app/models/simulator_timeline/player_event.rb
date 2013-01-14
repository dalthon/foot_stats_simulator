class SimulatorTimeline
  class PlayerEvent < SimulatorTimeline::Event
    attr_accessor :playing

    attr_reader :player, :reference, :substituted

    def initialize(event_handler, timeline, period_time, minute, options = {})
      @player, @reference, @status, substituted_index = options.values_at :player, :reference, :status, :substituted
      @playing  = true
      @status ||= "Titular"
      set_substituted(substituted_index) if substituted_index
      super(event_handler, timeline, period_time, minute, options)
    end

    def to_foot_stats
      {
        "@Jogador"    => @player.full_name,
        "@IdJogador"  => @player.source_id,
        "@Status"     => @status,
        "@Substituto" => (@substituted || ''),
        "@Periodo"    => (@substituted ? SimulatorMatch::STATUS_MAP[SimulatorMatch::STATUSES[@period_time]] : 'Nenhum'),
        "@Minuto"     => @minute.to_s
      }
    end

    def self.remove(timeline, reference)
      timeline.current_home_players.delete_all{ |event| event.reference == reference }
      timeline.current_visitor_players.delete_all{ |event| event.reference == reference }
    end

    def self.to_foot_stats(array_of_players)
      fuck_collection 'Jogador', array_of_players.map(&:to_foot_stats)
    end

    def method_missing(method_name, *args, &block)
      if @player.respond_to?(method_name)
        @player.public_send(method_name, *args, &block)
      else
        super(method_name, *args, &block)
      end
    end

    protected
    def set_substituted(substituted_index)
      player_collection = if @player.simulator_team == @timeline.home_team
        @timeline.current_home_players
      else
        @timeline.current_visitor_players
      end
      substituted = player_collection.find_all{ |p| p.playing }[substituted_index]
      substituted.playing = false
      @substituted = substituted.full_name

      event_handler.narration :substitution, new_player: @player.nickname, leaving_player: @substituted
    end

    def apply_event
      if @player.simulator_team == @timeline.home_team
        @timeline.current_home_players << self
      else
        @timeline.current_visitor_players << self
      end
    end
  end
end