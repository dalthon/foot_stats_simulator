class SimulatorTimeline
  class NarrationEvent < SimulatorTimeline::Event
    attr_reader :message, :source_id, :moment, :reference

    def initialize(event_handler, timeline, period_time, minute, options = {})
      super(event_handler, timeline, period_time, minute, options)
      @message, @reference = options.values_at :message, :reference
      @source_id = @timeline.timeline_rand(10**7)+1
      @moment    = format "%02d:%02d", period_time, @timeline.timeline_rand(60)
    end

    def to_foot_stats
      {
        "@Id"         => @source_id,
        "IdEquipe"    => "",
        "NomeEquipe"  => "",
        "IdJogador"   => "",
        "NomeJogador" => "",
        "Periodo"     => SimulatorMatch::STATUS_MAP[SimulatorMatch::STATUSES[@period_time]],
        "Momento"     => @moment,
        "Descricao"   => @message,
        "Acao"        => ""
      }
    end

    def self.remove(timeline, reference)
      timeline.narration.delete_if{ |event| event.reference == reference }
    end

    def self.to_foot_stats(array_of_narrations)
      fuck_collection 'Narracao', array_of_narrations.map(&:to_foot_stats)
    end

    protected
    def apply_event
      @timeline.narration << self
    end
  end
end