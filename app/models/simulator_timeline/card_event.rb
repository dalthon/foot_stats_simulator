class SimulatorTimeline
  class CardEvent < SimulatorTimeline::Event
    attr_reader :player, :type, :reference

    def initialize(event_handler, timeline, period_time, minute, options = {})
      @player, @type, @reference = options.values_at :player, :type, :reference
      @type ||= :yellow
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
      timeline.home_cards.delete_if{ |event| event.reference == reference }
      timeline.visitor_cards.delete_if{ |event| event.reference == reference }
    end

    def self.to_foot_stats(array_of_cards)
      fuck_collection 'Cartoes', array_of_cards.map(&:to_foot_stats)
    end

    protected
    def apply_event
      if @player.simulator_team == @timeline.home_team
        @timeline.home_cards << self
      else
        @timeline.visitor_cards << self
      end

      card_kind = (@type == :yellow) ? 'amarelo' : 'vermelho'
      event_handler.narration :card, current_player: @player.nickname, card_kind: card_kind
    end
  end
end