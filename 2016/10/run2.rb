bots = {}

class Bot
  attr_reader :id

  def initialize(id)
    @id = id
    @chips = []
  end

  def chip1
    @chips.first
  end

  def action?
    @chips.size.eql?(2) && !@low_bot.nil? && !@high_bot.nil?
  end

  def is_compare?(a, b)
    return false if @compare.nil?
    [a, b].sort.join("-").eql?(@compare)
  end

  def code(low_bot, high_bot)
    @low_bot = low_bot
    @high_bot = high_bot
    self
  end

  def process(bots)
    return unless self.action?
    @compare = @chips.join("-")
    bots[@low_bot].get(@chips.shift)
    bots[@high_bot].get(@chips.pop)
  end

  def get(chip)
    raise "already have 2 chips" if @chips.size >= 2
    @chips << chip
    @chips.sort!
  end
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  sl = line.split(" ")
  if line.include?("goes to bot")
    value = sl[1].to_i
    bot = "#{sl[4]}#{sl[5]}"
    bots[bot] ||= Bot.new(bot)
    bots[bot].get(value)
  else
    from = "#{sl[0]}#{sl[1]}"
    to_low = "#{sl[5]}#{sl[6]}"
    to_high = "#{sl[10]}#{sl[11]}"
    bots[to_low] ||= Bot.new(to_low)
    bots[to_high] ||= Bot.new(to_high)
    bots[from] ||= Bot.new(from)
    bots[from] = bots[from].code(to_low, to_high)
  end
end

can_move = bots.select { |k, v| v.action? }

while can_move.size > 0
  can_move.each { |k, v| v.process(bots) }
  can_move = bots.select { |k, v| v.action? }
end

puts bots["output0"].chip1 * bots["output1"].chip1 * bots["output2"].chip1
