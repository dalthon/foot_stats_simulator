# It was the night before Christmas and all through the house, not a creature was coding: UTF-8, not even with a mouse.

class SimulatorMatch < ActiveRecord::Base
  STATUS_MAP = {
    not_started:         'Partida não iniciada',
    first_period:        'Primeiro tempo',
    first_interval:      'Intervalo 1',
    second_period:       'Segundo tempo',
    second_interval:     'Intervalo 2',
    first_prorrogation:  'Prorrogação 1',
    third_interval:      'Intervalo 3',
    second_prorrogation: 'Prorrogação 2',
    penalties:           'Disputa de Pênaltis',
    finished:            'Partida encerrada',
    stopped_match:       'Partida interrompida',
    canceled:            'Partida cancelada'
  }

  STATUS_SEQUENCE = {
    not_started:          0,
    first_period:         1,
    first_interval:       2,
    second_period:        3,
    second_interval:      4,
    first_prorrogation:   5,
    third_interval:       6,
    second_prorrogation:  7,
    penalties:            8,
    finished:             9,
    stopped_match:       10,
    canceled:            11
  }

  STATUSES = [
    :not_started,
    :first_period,
    :first_interval,
    :second_period,
    :second_interval,
    :first_prorrogation,
    :third_interval,
    :second_prorrogation,
    :penalties,
    :finished,
    :stopped_match,
    :canceled
  ]

  belongs_to :simulator_championship
  belongs_to :home_simulator_team,    foreign_key: 'home_team_id',    class_name: 'SimulatorTeam'
  belongs_to :visitor_simulator_team, foreign_key: 'visitor_team_id', class_name: 'SimulatorTeam'

  after_create :update_by_timeline

  def home_team
    home_simulator_team
  end

  def visitor_team
    visitor_simulator_team
  end

  def timeline
    @timeline ||= SimulatorTimeline.new(self, timeline_name)
  end

  def readable_status
    if status
      SimulatorMatch::STATUS_SEQUENCE[status.to_sym]
    else
      0
    end
  end

  def to_foot_stats_live
    update_by_timeline
    {
      "@IdPartida"      => source_id.to_s,
      "@Placar"         => [home_score, visitor_score].join('-'),
      "@PlacarPenaltis" => [home_penalties_score, visitor_penalties_score].join('-'),
      "@Data"           => date.strftime("%-m/%e/%Y %I:%M:%S %p"),
      "@Periodo"        => readable_status,
      "@Arbitro"        => referee,
      "@Estadio"        => stadium,
      "@Cidade"         => city,
      "@Pais"           => country,
      "@TemNarracao"    => ((narration) ? 'Sim' : 'Não'),
      "@Rodada"         => round.to_s,
      "@Fase"           => phase,
      "@Taca"           => cup,
      "@Grupo"          => group,
      "Mandante" => {
        "@Id"       => home_team.source_id,
        "@Nome"     => home_team.full_name,
        "@Tecnico"  => "Técnico do #{home_team.full_name}",
        "Gols"      => SimulatorTimeline::GoalEvent.to_foot_stats(timeline.home_goals),
        "Cartoes"   => SimulatorTimeline::CardEvent.to_foot_stats(timeline.home_cards),
        "Escalacao" => SimulatorTimeline::PlayerEvent.to_foot_stats(timeline.home_players),
      },
      "Visitante" => {
        "@Id"       => visitor_team.source_id,
        "@Nome"     => visitor_team.full_name,
        "@Tecnico"  => "Técnico do #{visitor_team.full_name}",
        "Gols"      => SimulatorTimeline::GoalEvent.to_foot_stats(timeline.visitor_goals),
        "Cartoes"   => SimulatorTimeline::CardEvent.to_foot_stats(timeline.visitor_cards),
        "Escalacao" => SimulatorTimeline::PlayerEvent.to_foot_stats(timeline.visitor_players),
      }
    }
  end

  def to_foot_stats_narration
    {
      "Campeonato" => {
        "@Id"        => simulator_championship.source_id.to_s,
        "@Nome"      => simulator_championship.name,
        "@Temporada" => Time.now.year.to_s,
        "Partida" => {
          "@Id"     => source_id.to_s,
          "@Rodada" => round.to_s,
          "@Placar" => [home_score, visitor_score].join('-'),
          "@TemDisputaPenaltis" => "Nao"
        },
        "Narracoes" => SimulatorTimeline::NarrationEvent.to_foot_stats(timeline.narration)
      }
    }
  end

  def to_foot_stats
    update_by_timeline
    {
      "@Id"    => source_id.to_s,
      "Equipe" => [
        {
          "@Id"             => home_team.source_id.to_s,
          "@Nome"           => home_team.full_name,
          "@Placar"         => " ",
          "@PlacarPenaltis" => "",
          "@Tipo"           => "Mandante"
        },
        {
          "@Id"             => visitor_team.source_id.to_s,
          "@Nome"           => visitor_team.full_name,
          "@Placar"         => " ",
          "@PlacarPenaltis" => "",
          "@Tipo"           => "Visitante"
        }
      ],
      "Data"           => date.strftime("%-m/%e/%Y %I:%M:%S %p"),
      "Status"         => readable_status,
      "Arbitro"        => referee,
      "Estadio"        => stadium,
      "Cidade"         => city,
      "Estado"         => state,
      "Pais"           => country,
      "TemEstatistica" => ((statistic) ? 'Sim' : 'Não'),
      "TemNarracao"    => ((narration) ? 'Sim' : 'Não'),
      "Rodada"         => round.to_s,
      "Fase"           => phase,
      "Taca"           => cup,
      "Grupo"          => group,
      "NumeroJogo"     => game_number.to_s,
      "AoVivo"         => ((live) ? 'Sim' : 'Não')
    }
  end

  protected
  def update_by_timeline
    return if readable_status >= SimulatorMatch::STATUS_SEQUENCE[:finished]
    timeline.update_match
  end

  class << self
    def to_foot_stats
      {
        "Partidas" => {
          "Partida" => all.map(&:to_foot_stats)
        }
      }
    end

    def create_dummy(options)
      championship = SimulatorChampionship.find_by_source_id options[:championship_source_id]
      home_team    = SimulatorTeam.find_by_source_id options[:home_team_id]
      visitor_team = SimulatorTeam.find_by_source_id options[:visitor_team_id]

      params = {
        simulator_championship_id: championship.id,
        home_team_id:              home_team.id,
        visitor_team_id:           visitor_team.id,
        timeline_name:             options[:timeline_name],
        source_id:                 dummy_source_id,
        date:                      dummy_date(options[:minutes_from_now]),
        referee:                   Faker::Name.name,
        stadium:                   "Estádio #{Faker::Name.name}",
        city:                      Faker::Address.city,
        state:                     dummy_state,
        country:                   Faker::Address.country,
        statistic:                 dummy_statistic,
        narration:                 options[:narration],
        round:                     dummy_round(championship, options[:round]),
        phase:                     dummy_phase(championship, options[:phase]),
        cup:                       '',
        group:                     '',
        game_number:               dummy_game_number(championship),
        live:                      options[:live],
        home_team_name:            home_team.full_name,
        home_score:                0,
        home_penalties_score:      nil,
        visitor_team_name:         visitor_team.full_name,
        visitor_score:             0,
        visitor_penalties_score:   nil,
        timeline_random_seed:      Random.new_seed
      }

      match = self.create params
      match
    end

    protected
    def dummy_source_id
      source_id = rand(10000)
      if self.where(source_id: source_id).exists?
        dummy_source_id
      else
        source_id
      end
    end

    def dummy_date(minutes_from_now)
      minutes_from_now.minutes.from_now
    end

    def dummy_state
      ['SP', 'RJ', 'MG', 'EX'].sample
    end

    def dummy_statistic
      [true, false].sample
    end

    def dummy_round(championship, round)
      if round
        round
      else
        championship.classification.round
      end
    end

    def dummy_phase(championship, phase)
      if phase
        phase
      else
        championship.classification.phase
      end
    end

    def dummy_game_number(championship)
      championship.simulator_matches.count + 1
    end
  end
end