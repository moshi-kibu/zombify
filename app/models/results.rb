
class Results

  SCENARIOS = {
  invalid_user_code: {
    response_message: "invalid user code",
  },
  human_attack_self: {
    response_message: "Attack yourself all you want, I guess...",
  },
  human_attack_human: {
    response_message: "Why are you wasting precious cures?!",
  },
  zombie_attack_zombie: {
    response_message: "Why are you biting each other, Children?",
  },
  user_converts_H_to_Z: {
    response_message: "Mmmmmm....Brainsssss.....You have added to the horde.",
    post_message: ["%s has bitten %s","New Zombie"],
    user_state: [true, 300],
    opponent_state: [true,0]
  },
  user_fail_converts_H_to_Z: {
    response_message: "The human has escaped. You still crave brains... ",
    post_message: ["%s has let %s get away!","Near Miss"],
    user_state: [true,0],
    opponent_state: [false, 100]
  },
  successful_cure: {
    response_message:  "You have successfully applied the cure!",
    post_message: ["%s has cured %s","Human Reversion"],
    user_state: [false, 500],
    opponent_state: [false, 500]
  },
  failed_cure: {
    response_message: "Your cure has failed. You feel a rage rising and crave delicious brains...",
    post_message: ["%s failed to cure %s and got infected!","Cure Failed"],
    user_state: [true,0],
    opponent_state: [true, 100]
  },
  no_cure_attempt: {
    response_message: "You do not have the cure! You have been bitten. Brainsssss....",
    post_message: ["%s was bitten by %s","New Zombie"],
    user_state: [true,0],
    opponent_state: [true, 100]
  }
}

  attr_reader :response

  def initialize(user, opponent, user_win)
    @user = user
    @opponent = opponent
    @win = user_win
    determine_responses
  end

  private

  def determine_responses
    scenario = determine_scenario
    post = SCENARIOS[scenario][:post_message]
    user_state = SCENARIOS[scenario][:user_state]
    opponent_state = SCENARIOS[scenario][:opponent_state]

    create_post(sprintf(post[0],@user.name, @opponent.name),post[1]) if post
    update_user(user_state[0], user_state[1]) if user_state
    update_opponent(opponent_state[0], opponent_state[1]) if opponent_state
    check_stats
    @response = SCENARIOS[scenario][:response_message]
  end

  def determine_scenario
    return :invalid_user_code if @opponent == "invalid"
    return :human_attack_self if @opponent == @user
    return :zombie_attack_zombie if @user.infected && @opponent.infected
    return :human_attack_human if !@user.infected && !@opponent.infected
    return :user_converts_H_to_Z if @user.infected && @win
    return :user_fail_converts_H_to_Z if @user.infected && !@win
    return :successful_cure if @user.can_cure && @win
    return :failed_cure if @user.can_cure && !@win
    return :no_cure_attempt if !@user.can_cure && !@win
  end

  def create_post(body, title, audience = "both")
    Post.create(body: body, title: title, audience: audience)
  end

  def update_user(infected, points)
    @user.update_attributes(infected: infected, points: @user.points += points, handle: @user.generate_handle)
  end

  def update_opponent(infected, points)
    @opponent.update_attributes(infected: infected, points: @opponent.points += points, handle: @opponent.generate_handle)
  end

  def check_stats
    if Stats.all_human?
      @message = Message.human_messages.last
      create_post(@message.description, @message.title, "human")
      Game.end
    elsif Stats.all_zombie?
      @message = Message.zombie_messages.last
      create_post(@message.description, @message.title, "zombie")
      Game.end
    else
      remaining_stats(Stats.percent_zombies)
    end
  end

  def remaining_stats(zombie_percentage)
    zombie_messages = Message.zombie_messages
    human_messages = Message.human_messages
    case zombie_percentage
      when 90..93
        create_post(zombie_messages[7].description,zombie_messages[7].title,"human")
        create_post(human_messages[7].description, human_messages[7].title, "zombie")
      when 50..53
        create_post(zombie_messages[6].description,zombie_messages[6].title,"zombie")
        create_post(human_messages[6].description,human_messages[6].title,"human")
    end
  end

end







#
