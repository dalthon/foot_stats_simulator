class SimulatorTimeline
  class EventHandler
    def initialize(timeline, period_time, minute)
      @timeline, @period_time, @minute = timeline, period_time, minute
    end

    def add_goal(player, options={})
      options = { player: player }.merge(options)
      GoalEvent.new self, @timeline, @period_time, @minute, options
    end

    def remove_goal(reference)
      GoalEvent.remove @timeline, reference
    end

    def add_card(player, options={})
      options = { player: player }.merge(options)
      CardEvent.new self, @timeline, @period_time, @minute, options
    end

    def add_yellow_card(player, options={})
      options = { player: player, type: :yellow }.merge(options)
      add_card player, options
    end

    def add_red_card(player, options={})
      options = { player: player, type: :red }.merge(options)
      add_card player, options
    end

    def remove_card(reference)
      CardEvent.remove @timeline, reference
    end

    def escalation(players)
      players.each do |player|
        self.player(player)
      end
    end

    def player(player, options={})
      options = { player: player }.merge(options)
      PlayerEvent.new self, @timeline, @period_time, @minute, options
    end

    def remove_player(reference)
      PlayerEvent.remove @timeline, reference
    end

    def narration(message_name = :lorem, options = {})
      message = if message_name.is_a?(String)
        message_name
      else
        message = Lorem.new(@timeline, @period_time, @minute, options).public_send message_name
      end
      options = { message: message }.merge(options)
      NarrationEvent.new self, @timeline, @period_time, @minute, options
    end

    def remove_narration(reference)
      NarrationEvent.remove @timeline, reference
    end

    protected
    def event(type, *args)
      [@period_time, @minute, type, args]
    end
  end
end