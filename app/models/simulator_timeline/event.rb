class SimulatorTimeline
  class Event
    attr_reader :period_time, :minute, :event_handler

    def initialize(event_handler, timeline, period_time, minute, options = {})
      @event_handler, @timeline, @period_time, @minute = event_handler, timeline, period_time, minute
      apply_event
    end

    def <=>(other)
      [@period_time, @minute] <=> [other.period_time, other.minute]
    end

    # Yeah... FootStats fucks collection...
    def self.fuck_collection(key, collection)
      case collection.size
      when 0
        nil
      when 1
        { key => collection.first }
      else
        { key => collection }
      end
    end
  end
end