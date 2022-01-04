require "set"

class State
  def initialize(state)
    # @state = Array.new(9) { 0 }
    @state = state
    # state[0] : who is next (0=Player, 1=Boss)
    # state[1] : player HP
    # state[2] : player Mana
    # state[3] : boss HP
    # state[4] : boss damage
    # state[5] : player - shield turns (>=0)
    # state[6] : player - poison turns (>=0)
    # state[7] : player - recharge turns (>=0)
    # state[8] : mana burned
  end

  def spells_available
    result = []
    result << :missile if @state[2] >= 53
    result << :drain if @state[2] >= 73
    result << :shield if @state[2] >= 113 && @state[5].eql?(0)
    result << :poison if @state[2] >= 173 && @state[6].eql?(0)
    result << :recharge if @state[2] >= 229 && @state[7].eql?(0)
    result
  end

  def play_turn(memo)
    return if memo[:seen].include?(@state)
    memo[:seen] << @state

    newstate = @state.dup

    # armor booster
    player_armor = 0
    if @state[5] > 0
      player_armor += 7
      newstate[5] = @state[5] - 1
    end

    # poison
    if @state[6] > 0
      newstate[3] -= 3
      newstate[6] = @state[6] - 1
    end

    # recharge
    if @state[7] > 0
      newstate[2] += 101
      newstate[7] = @state[7] - 1
    end

    if newstate[3] <= 0
      memo[:burns] << @state[8] # record the manaburn
      return
    end

    newstate[0] = 1 - @state[0]
    return if newstate[1] <= 0 # player died - not computing anything

    case @state[0]
    when 0 # player
      return if newstate[2] < 53 # player lost - we cannot cast any spell
      State.new(newstate).spells_available.each do |spell|
        case spell
        when :missile
          as = newstate.dup
          as[2] -= 53 # mana cost
          as[8] += 53
          as[3] -= 4 # damage done
          State.new(as).play_turn(memo)
        when :drain
          as = newstate.dup
          as[2] -= 73 # mana cost
          as[8] += 73
          as[1] += 2 # healing
          as[3] -= 2 # damage done
          State.new(as).play_turn(memo)
        when :shield
          as = newstate.dup
          as[2] -= 113 # mana cost
          as[8] += 113
          as[5] = 6 # mark the turns active (slot 5)
          State.new(as).play_turn(memo)
        when :poison
          as = newstate.dup
          as[2] -= 173 # mana cost
          as[8] += 173
          as[6] = 6 # mark the turns active (slot 6)
          State.new(as).play_turn(memo)
        when :recharge
          as = newstate.dup
          as[2] -= 229 # mana cost
          as[8] += 229
          as[7] = 5 # mark the turns active (slot 6)
          State.new(as).play_turn(memo)
        else
          raise "unknown spell #{spell}"
        end
      end
    when 1 # boss
      as = newstate.dup
      as[1] = newstate[1] - [newstate[4] - player_armor, 1].max
      return if as[1] <= 0 # player died - not computing anything
      State.new(as).play_turn(memo)
    else
      raise "unknown player #{@state[0]}"
    end
  end
end

initial_state = [
  0, # Player starts
  50, # Player HP
  500, # Player Mana
  51, # Boss HP
  9, # Boss Damage
  0, # Shields Turns
  0, # Poison Turns
  0, # Recharge Turns
  0, # Mana Burned so far
]

memo = { seen: Set.new, burns: Set.new }
State.new(initial_state).play_turn(memo)

puts memo[:burns].min
