# encoding: UTF-8

class SimulatorClassification
  def initialize(championship)
    @championship = championship
  end

  def to_foot_stats
    if @championship.has_classification?
      championship_classification
    else
      classification_missing
    end
  end

  def round
    if last_match
      last_match.round
    else
      1
    end
  end

  def phase
    if last_match
      last_match.phase
    else
      'Primeira Fase'
    end
  end

  def cup
    if last_match
      last_match.cup
    else
      ''
    end
  end

  protected
  def championship_classification
  {
    "Campeonato" => {
      "@Id" => @championship.source_id.to_s,
      "@Nome" => @championship.name,
      "@Temporada" => season,
      "@Fase" => phase,
      "Classificacoes" => {
        "Classificacao" => {
          "@Taca" => cup,
          "Equipe" => foot_stats_teams
        }
      }
    }
  }
  end

  def last_match
    @last_match ||= @championship.simulator_matches.order('date').last
  end

  def season
    if @championship.name.match(/20\d{2}/)
      $~[0]
    else
      Time.now.year
    end.to_s
  end

  def classification_missing
    {
      "Erro" => {
        "@Mensagem" => "Este campeonato não contem classificação cadastrada."
      }
    }
  end

  def foot_stats_teams
    @championship.simulator_championship_participations.to_foot_stats
  end
end

# {
#     "Campeonato": {
#         "@Id": "198",
#         "@Nome": "Camp. Mineiro 2012",
#         "@Temporada": "2012",
#         "@Fase": "Primeira Fase",
#         "Classificacoes": {
#             "Classificacao": {
#                 "@Taca": "",
#                 "Equipe": [
#                 {
#                     "@Id": "1487",
#                     "@Nome": "América (Teófilo Otoni)",
#                     "@Grupo": "",
#                     "Posicao": "1",
#                     "Pontos_Ganhos": "30",
#                     "Jogos": "10",
#                     "Vitorias": "10",
#                     "Empates": "0",
#                     "Derrotas": "0",
#                     "Gols_Pro": "23",
#                     "Gols_Contra": "9",
#                     "Saldo_Gols": "14",
#                     "Vitorias_Casa": "5",
#                     "Empates_Casa": "0",
#                     "Derrotas_Casa": "0",
#                     "Vitorias_Fora": "5",
#                     "Empate_Fora": "0",
#                     "Derrotas_Fora": "0",
#                     "Aproveitamento": "",
#                     "Ponto_Maximo": "33"
#                 }
#                 ]
#             }
#         }
#     }
# }