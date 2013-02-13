class Notifications < ActionMailer::Base
  default from: "noreply@espaceladder.com"

  def tournament_invitation(invite)
    @invite = invite
    @tournament = invite.tournament
    @inviter = invite.owner
    mail(:to => invite.email, :subject => "#{invite.owner.name} has invited you to the ESpace Ping Pong Ladder")
  end

  def game_confirmation(user, game)
    @user = user
    @game = game
    @tournament = @game.tournament
    mail(:to => @user.email, :subject => "Confirm game")
  end

  def challenged(challenge)
    @challenge = challenge
    @defender = challenge.defender
    @challenger = challenge.challenger
    @tournament = challenge.tournament
    mail(:to => @defender.email, :subject => "You have been challenged")
  end
end
