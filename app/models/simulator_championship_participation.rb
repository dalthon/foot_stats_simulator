class SimulatorChampionshipParticipation < ActiveRecord::Base
  belongs_to :simulator_team
  belongs_to :simulator_championship

  def score
    return @score if @score

    @points        = 0
    @matches_count = 0

    @victories_count = 0
    @draws_count     = 0
    @loss_count      = 0

    @home_victories = 0
    @home_draws     = 0
    @home_loss      = 0

    @visitor_victories = 0
    @visitor_draws     = 0
    @visitor_loss      = 0

    @team_goals    = 0
    @against_goals = 0

    simulator_championship.simulator_matches.where(home_team_id: simulator_team_id).each do |match|
      match.timeline

      @matches_count += 1

      @team_goals    += match.home_score
      @against_goals += match.visitor_score

      if match.home_score > match.visitor_score
        @victories_count += 1
        @home_victories  += 1

        @points += 3
      else
        if match.home_score == match.visitor_score
          @draws_count += 1
          @home_draws  += 1

          @points += 1
        else
          @loss_count += 1
          @home_loss   += 1
        end
      end
    end

    simulator_championship.simulator_matches.where(visitor_team_id: simulator_team_id).each do |match|
      match.timeline

      @matches_count += 1

      @team_goals    += match.visitor_score
      @against_goals += match.home_score

      if match.visitor_score > match.home_score
        @victories_count   += 1
        @visitor_victories += 1

        @points += 3
      else
        if match.visitor_score == match.home_score
          @draws_count   += 1
          @visitor_draws += 1

          @points += 1
        else
          @loss_count   += 1
          @visitor_loss += 1
        end
      end
    end

    @score = [
      @points,
      (@team_goals - @against_goals),
      @victories_count,
      @home_victories
    ]
  end

  def to_foot_stats
    {
      "@Id"            => simulator_team_id.to_s,
      "@Nome"          => simulator_team.full_name,
      "@Grupo"         => "",
      "Pontos_Ganhos"  => @points.to_s,
      "Jogos"          => @matches_count.to_s,
      "Vitorias"       => @victories_count.to_s,
      "Empates"        => @draws_count.to_s,
      "Derrotas"       => @loss_count.to_s,
      "Gols_Pro"       => @team_goals.to_s,
      "Gols_Contra"    => @against_goals.to_s,
      "Saldo_Gols"     => (@team_goals - @against_goals).to_s,
      "Vitorias_Casa"  => @home_victories.to_s,
      "Empates_Casa"   => @home_draws.to_s,
      "Derrotas_Casa"  => @home_loss.to_s,
      "Vitorias_Fora"  => @visitor_victories.to_s,
      "Empate_Fora"    => @visitor_draws.to_s,
      "Derrotas_Fora"  => @visitor_loss.to_s,
      "Aproveitamento" => "",
      "Ponto_Maximo"   => (@matches_count*3).to_s
    }
  end

  def self.to_foot_stats
    index = 0
    self.all.map do |participation|
      [ participation.score, participation.to_foot_stats ]
    end.sort_by do |score, foot_stats_data|
      score
    end.reverse.map do |score, foot_stats_data|
      index += 1
      foot_stats_data['Posicao'] = index.to_s
      foot_stats_data
    end
  end
end