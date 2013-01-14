# encoding: UTF-8

class SimulatorTimeline
  module LoremMessages

    def not_started_message
      "#{ home_team.full_name } X #{ visitor_team.full_name }, aqui no estádio #{ match.stadium }, esse jogo promete!"
    end

    def first_period_message
      "Árbitro #{match.referee} apita início da partida, #{ home_team.full_name } e #{ visitor_team.full_name } entram em campo com tudo!"
    end

    def first_interval_message
      "Fim do primeiro tempo #{ home_team.full_name } #{ home_score } X #{ visitor_team.full_name } #{ visitor_score }, vamos ver se no segundo tempo esses jogadores param de moleza... estão parecendo programadores!"
    end

    def second_period_message
      "Início do segundo tempo, <%= current_player %> tenta dar o primeiro passe em direção ao campo adversário, mas pisa na bola e escorrega."
    end

    def second_interval_message
      "Esse jogo está muito morto... Vamos ver se ele se decide após o segundo intervalo."
    end

    def first_prorrogation_message
      "Jogo disputado, #{ home_team.full_name } X #{ visitor_team.full_name }, quem sabe esse jogo se decide nessa prorrogação!"
    end

    def third_interval_message
      "Uma pequena pausa, em breve os jogadores voltam ao campo."
    end

    def second_prorrogation_message
      "Morte súbita! Os jogadores já estão quase mortos de cansaço..."
    end

    def penalties_message
      "Agora é tudo ou nada... Decisão nos penaltis! <%= current_player %> já se posiciona para o primeiro chute a gol."
    end

    def finished_message
      "Fim de jogo! #{ home_team.full_name } #{ home_score } X #{ visitor_team.full_name } #{ visitor_score }, boa noite!"
    end

    def stopped_match_message
      [
        "Partida parada, <%= current_home_player %> chuta o saco de <%= current_visitor_player %>, #{ visitor_team.full_name } se mobiliza.",
        "Partida parada, <%= trolled_person %> invade o campo e rouba a bola.",
        "Partida parada, <%= trolled_person %> invade o campo e ataca a bandeirinha gostosa.",
      ]
    end

    def canceled_message
      [
        "Partida cancelada, os refletores realmente não estão funcionando nessa noite!",
        "Partida cancelada, a confusão é geral, os torcedores invadem o campo e a polícia tem que intervir!",
        "Partida cancelada, o árbitro #{match.referee} é atacado por um cão raizoso que invadiu o campo, e é levado para tomar uma anti-rábica"
      ]
    end

    def goal_message
      "GOL! #{ home_team.full_name } #{ home_score } X #{ visitor_team.full_name } #{ visitor_score } - <%= current_player %> <%= goal_kind %> para o <%= player_team %>"
    end

    def goal_kind_message
      [
        'mata no peito, domina e chuta no ângulo! Gol',
        'cobra a falta com precisão e marca o gol',
        'chuta, e o goleiro dá um frango! Entre as pernas! Gol',
        'dá um peixinho e finaliza'
      ]
    end

    def lorem_message
      cornerkick_message + sidekick_message + foul_message + funny_message
    end

    def funny_message
      [
        'E agora na arquibancada, alguém acaba de mostrar um cartaz escrito "CALA A BOCA GALVÃO".',
        'O que é isso? O <%= trolled_person %> está dando uma de técnico da seleção alemã enfiando o dedo no nariz!',
        'Futebol sem preconceitos: Na arquibancada, Richarlyson e seu novo namorado <%= trolled_person %>, acompanham esse jogo abraçadinhos!',
        'Uma ativista peladona invade o campo para protestar contra o aquecimento global. <%= trolled_person %> irritado, a retira do campo.'
      ]
    end

    def cornerkick_message
      [
        "<%= current_home_player %> mandou a bola pra escaneio, <%= current_visitor_player %> parte para a cobrança.",
        "<%= current_visitor_player %> mandou a bola pra escaneio, <%= current_home_player %> parte para a cobrança."
      ]
    end

    def sidekick_message
      [
        "Lateral a favor do <%= home_team.full_name %>, <%= current_home_player %> é quem vai cobrar.",
        "Lateral a favor do <%= visitor_team.full_name %>, <%= current_visitor_player %> é quem vai cobrar."
      ]
    end

    def foul_message
      [
        "<%= current_player %> recebeu uma falta porque <%= infringement %>."
      ]
    end

    def substitution_message
      [
        "<%= new_player %> entra em campo no lugar de <%= leaving_player %>.",
        "<%= leaving_player %> já deu o que tinha que dar, agora é <%= new_player %> que entra em campo."
      ]
    end

    def card_message
      "<%= current_player %> recebeu um cartão <%= card_kind %> porque <%= infringement %>"
    end

    def card_kind_message
      [
        'amarelo',
        'vermelho'
      ]
    end

    def infringement_message
      [
        'xingou a mãe do juíz de quenga! Como ele descobriu?',
        '<%= a_knock %> <%= current_player %>.',
        'chutou <%= an_animal %> que invadiu o campo.',
        'saiu correndo sem camisa, com no peito escrito "<%= trolled_person.upcase %> EU TE AMO!".'
      ]
    end

    def a_knock_message
      [
        'deu um chute no saco do',
        'deu um carrinho por tráz no',
        'deu uma voadora no peito do',
        'apertou os peitinhos do'
      ]
    end

    def an_animal_message
      [
        'uma capivara',
        'um urubú',
        "o <%= trolled_person %> peladão",
        'a mãe do juíz'
      ]
    end

    def trolled_person_message
      [
        'Ruschel', 'Dayyán', 'Ettore', 'Cruz',
        'Enio', 'Lucas', 'Tomas',
        'Akita', 'Pisano', 'Abilheira'
      ]
    end

    def current_home_player_message
      current_home_players.map(&:nickname)
    end

    def current_visitor_player_message
      current_visitor_players.map(&:nickname)
    end

    def home_player_message
      home_players.map(&:nickname)
    end

    def visitor_player_message
      visitor_players.map(&:nickname)
    end

    def player_message
      all_players.map(&:nickname)
    end

    def current_player_message
      all_current_players.map(&:nickname)
    end
  end
end