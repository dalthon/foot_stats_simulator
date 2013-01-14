module FootStatsSimulator
  class ApiController < ::FootStatsSimulator::ApplicationController
    skip_before_filter :verify_authenticity_token

    def championship
      render_foot_stats SimulatorChampionship.to_foot_stats
    end

    def championship_teams
      championship = SimulatorChampionship.find_by_source_id params[:IdCampeonato]
      render_foot_stats championship.simulator_teams.to_foot_stats
    end

    def team_players
      team = SimulatorTeam.find_by_source_id params[:Equipe]
      render_foot_stats team.simulator_players.to_foot_stats
    end

    def championship_classification
      championship = SimulatorChampionship.find_by_source_id(params[:Campeonato])
      render_foot_stats championship.classification.to_foot_stats
    end

    def championship_match
      championship = SimulatorChampionship.find_by_source_id(params[:Campeonato])
      render_foot_stats championship.simulator_matches.to_foot_stats
    end

    def championship_round_match
      championship = SimulatorChampionship.find_by_source_id(params[:Campeonato])
      render_foot_stats championship.simulator_matches.where(round: params[:Rodada]).to_foot_stats
    end

    def live_match
      render_foot_stats SimulatorMatch.find_by_source_id(params[:IdPartida]).to_foot_stats_live
    end

    def match_narration
      render_foot_stats SimulatorMatch.find_by_source_id(params[:Partida]).to_foot_stats_narration
    end
  end
end
