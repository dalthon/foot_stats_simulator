class SimulatorTimeline
  class Minute
    def initialize(timeline, period_time, minute)
      @timeline, @period_time, @minute = timeline, period_time, minute
      yield(self) if block_given?
    end

    def event_handler
      @event_handler ||= EventHandler.new(@timeline, @period_time, @minute)
    end

    def reached_time?
      @timeline.current_period_time > @period_time || (
        @timeline.current_period_time == @period_time && @timeline.current_minute >= @minute
      )
    end

    def method_missing(method_name, *args, &block)
      if event_handler.respond_to?(method_name)
        event_handler.public_send(method_name, *args, &block) if reached_time?
      else
        super(method_name, *args, &block)
      end
    end
  end
end