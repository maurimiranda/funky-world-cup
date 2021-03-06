class CupGroup < Sequel::Model
  one_to_many :matches, key: :group_id
  one_to_many :group_positions, key: :group_id

  subset(:groups_phase, :phase => "groups")

  def teams
    matches.map { |match| [match.host_team, match.rival_team] }.flatten.uniq
  end

  def positions_table
    GroupPosition.select.select_append{ Sequel.as(goals - received_goals, :diff)}.where(group_id: id).order(Sequel.desc(:points), Sequel.desc(:diff)).all
  end

  def matches_table
    Match.where(group_id: id).order(:start_datetime).all
  end
end
