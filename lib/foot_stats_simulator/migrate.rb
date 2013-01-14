ActiveRecord::Migration.create_table :simulator_championships do |t|
  t.integer :source_id
  t.string  :name
  t.boolean :has_classification
  t.integer :current_round
  t.integer :total_rounds
end

ActiveRecord::Migration.create_table :simulator_teams do |t|
  t.integer :source_id
  t.string  :full_name
  t.string  :city
  t.string  :country
end

ActiveRecord::Migration.create_table :simulator_championship_participations do |t|
  t.references :simulator_championship
  t.references :simulator_team
end

ActiveRecord::Migration.create_table :simulator_players do |t|
  t.references :simulator_team
  t.integer    :source_id
  t.string     :full_name
  t.string     :nickname
end

ActiveRecord::Migration.create_table :simulator_matches do |t|
  t.references :simulator_championship
  t.integer    :home_team_id
  t.integer    :visitor_team_id

  t.string     :timeline_name
  t.string     :timeline_status
  t.decimal    :timeline_random_seed

  t.integer    :source_id
  t.time       :date
  t.string     :status
  t.string     :referee
  t.string     :stadium
  t.string     :city
  t.string     :state
  t.string     :country
  t.boolean    :statistic
  t.boolean    :narration
  t.integer    :round
  t.string     :phase
  t.string     :cup
  t.string     :group
  t.integer    :game_number
  t.boolean    :live

  t.string     :home_team_name
  t.integer    :home_score
  t.integer    :home_penalties_score
  t.string     :visitor_team_name
  t.integer    :visitor_score
  t.integer    :visitor_penalties_score

  t.timestamps
end