module FootStatsSimulator
  class ApplicationController < ActionController::Base
    protected
    def render_foot_stats(data)
      render text: "<string xmlns=\"http://tempuri.org/\">#{data.to_json}</string>"
    end
  end
end
