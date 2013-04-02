class Notifications < ActionMailer::Base
  default from: "noreply@espaceladder.com"

  def tournament_invitation(invite)
    @invite = invite
    @tournament = invite.tournament
    @inviter = invite.owner
    mail(:to => invite.email, :subject => "ESpace: #{invite.owner.name} has invited you to the ESpace Ping Pong Ladder")
  end

  def game_confirmation(user, game)
    @user = user
    @game = game
    @tournament = @game.tournament
    mail(:to => @user.email, :subject => "ESpace: Confirm the game")
  end

  def challenged(challenge)
    @challenge = challenge
    @defender = challenge.defender
    @challenger = challenge.challenger
    @tournament = challenge.tournament
    mail(:to => @defender.email, :subject => "ESpace: You've' been challenged by #{challenge.challenger.name} -- put up or shut up!")
  end

  def challenge_reminder(challenge)
    @challenge = challenge
    mail(:to => @challenge.defender.email, :subject => "ESpace: Ladder Challenge reminder from #{challenge.challenger.name} -- get your game on!")
  end

end
