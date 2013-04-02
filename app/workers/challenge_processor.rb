class ChallengeProcessor
  def initialize(expired_at)
    @expired_at = expired_at
  end

  def self.perform
    processor = ChallengeProcessor.new(Time.zone.now.beginning_of_day)
    processor.process
    processor.notify
  end

  def process
    Challenge.active.where("expires_at < ?", @expired_at).find_each do |challenge|
      challenge.with_lock do
        time = Time.zone.now
        game = Game.new(:tournament => challenge.tournament, :owner => challenge.challenger, :confirmed_at => time)
        game.game_ranks.build(:user => challenge.challenger, :position => 1, :confirmed_at => time)
        game.game_ranks.build(:user => challenge.defender, :position => 2, :confirmed_at => time)
        game.save!
        challenge.update_attribute(:game, game)
        winner_rank = challenge.defender.rank
        loser_rank = challenge.challenger.rank
        riser = User.find(challenge.challenger.id)
        riser.rank = winner_rank
        riser.save
        diff = loser_rank - winner_rank
        movers = diff - 1
        unless movers == 0
          if movers > 1
            (1..movers).each do | mover|
              player = User.find_by_rank(winner_rank + mover)
              player.increment!(:rank)
            end
          else
            player = User.find_by_rank(winner_rank + 1)
            player.increment!(:rank)
          end
        end
        dropper = User.find(challenge.defender.id)
        dropper.increment!(:rank)
        Notifications.game_confirmation(challenge.challenger,game).deliver
      end
    end
  end

  def notify
    Challenge.active.each do | match |
    Notifications.challenge_reminder(match).deliver
    end
  end


  end
end
