class SimulatorTimeline
  class Lorem
    attr_reader :timeline, :period_time, :minute
    include LoremMessages

    def initialize(timeline, period_time, minute, options = {})
      @timeline, @period_time, @minute, @options = timeline, period_time, minute, options
    end

    def method_missing(method_name, *args, &block)
      return render(@options[method_name])                         if @options[method_name]
      return render(send("#{method_name}_message", *args, &block)) if respond_to?("#{method_name}_message")
      return @timeline.public_send(method_name, *args, &block)     if @timeline.respond_to?(method_name)
      super(method_name, *args, &block)
    end

    protected
    def render(sentence)
      normalized_sentence = sentence.is_a?(String) ? sentence : sample(sentence)
      eval Erubis::Eruby.new(normalized_sentence).src, binding
    end
  end
end