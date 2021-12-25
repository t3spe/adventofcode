class Dice
  attr_reader :rolls

  def initialize()
    @d = 100
    @rolls = 0
  end

  def roll
    @rolls += 1
    @d += 1
    @d = 1 if @d > 100
    @d
  end
end

class Player
  attr_reader :score

  def initialize(pos)
    @pos = pos - 1
    @pos = 10 if @pos.eql?(0)
    @score = 0
  end

  def advance(dice)
    adv = 0
    3.times { adv += dice.roll() }
    @pos += adv
    @pos = @pos % 10 if @pos > 9
    @score += (@pos + 1)
  end

  def won?
    @score >= 1000
  end
end

# p = [Player.new(4), Player.new(8)]
p = [Player.new(5), Player.new(6)]
d = Dice.new
pi = 0
over = false
total = 0

while !over
  p[pi].advance(d)
  if p[pi].won?
    total = p[1 - pi].score * d.rolls
    break
  end
  pi = 1 - pi
end

puts total
