class SimulatorTimeline
  class Period
    def initialize(timeline, period, options={})
      @timeline, @period = timeline, period
      add_narration(options) if @timeline.current_period_time >= period_time
    end

    def period_time
      SimulatorMatch::STATUS_SEQUENCE[@period] || @period.to_i
    end

    def at(minute, &block)
      Minute.new @timeline, period_time, minute, &block
    end

    protected
    def add_narration(options)
      if options[:narration]
        event_handler.narration options[:narration]
      else
        event_handler.narration @period
      end
    end

    def event_handler
      EventHandler.new(@timeline, SimulatorMatch::STATUS_SEQUENCE[@period], 0)
    end
  end
end