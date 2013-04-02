class User < ActiveRecord::Base
  belongs_to :preferred_service, :class_name => 'Service'
  has_many :services
  has_many :tournaments, :inverse_of => :owner, :foreign_key => :owner_id
  has_many :invites, :inverse_of => :owner, :foreign_key => :owner_id
  has_many :game_ranks

  def wins
    self.game_ranks.where(:position=>1).count
  end

  def losses
    self.game_ranks.where(:position=>2).count
  end

  def record
    [self.wins, self.losses]
  end

  def streak
    games=self.game_ranks.pluck(:position)
    games[0] == 1 ? outcome = "W" : outcome = "L"
    streak=1
    (1..games.length).each do |number|
      if games[number - 1] == games[number]
        streak+=1
      else
        return outcome + streak.to_s
      end
    end
    return outcome + streak.to_s
  end
end
