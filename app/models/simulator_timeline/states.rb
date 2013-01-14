class SimulatorTimeline
  class States
    def initialize(timeline)
      @timeline = timeline
      yield(self)
      finish_initialize
    end

    def add_transition(state, time, options = {})
      @timeline.states << [time, state, options]
    end

    def method_missing(method_name, *args, &block)
      if SimulatorMatch::STATUS_SEQUENCE[method_name]
        add_transition(method_name, args.first)
      else
        super(method_name, *args, &block)
      end
    end

    protected
    def finish_initialize
      @timeline.states.sort!
      insert_not_started_if_missing
      set_current_period_and_minute
    end

    def insert_not_started_if_missing
      first_state = @timeline.states.first
      if first_state.blank? || first_state[1] != :not_started
        minute = first_state[0] - 1 rescue 0
        @timeline.states.unshift [minute, :not_started, Hash.new]
      end
    end

    def set_current_period_and_minute
      delta = (Time.now - @timeline.match.date).to_i

      seconds, state, options = @timeline.states.reverse.find{|seconds, state, options| delta > seconds } || [0, :not_started, Hash.new]

      @timeline.current_period = state
      @timeline.current_minute = (delta - seconds)/60
    end
  end
end