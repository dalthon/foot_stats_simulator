FootStatsSimulator::Engine.routes.draw do

  match 'ListaCampeonatos'       => 'api#championship',                via: :post, as: 'championship'
  match 'ListaEquipesCampeonato' => 'api#championship_teams',          via: :post, as: 'championship_teams'
  match 'ListaJogadoresEquipe'   => 'api#team_players',                via: :post, as: 'team_players'
  match 'ListaClassificacao'     => 'api#championship_classification', via: :post, as: 'championship_classification'
  match 'ListaPartidas'          => 'api#championship_match',          via: :post, as: 'championship_match'
  match 'ListaPartidasRodada'    => 'api#championship_round_match',    via: :post, as: 'championship_round_match'
  match 'AoVivo'                 => 'api#live_match',                  via: :post, as: 'live_match'
  match 'Narracao'               => 'api#match_narration',             via: :post, as: 'match_narration'

end
