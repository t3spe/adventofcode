monke = nil
monkeys = {}

class Monke 
  attr_accessor :items, :test, :tc, :fc, :rawop, :inspc

  def initialize
    @items = []
    @inspc = 0
  end

  def op(old)
    new = 0
    Kernel.eval(@rawop)
    new # return the new value
  end
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  if line.start_with?("Monkey")
    monke = line.split(" ")[1].split(":")[0].to_i
    monkeys[monke] ||= Monke.new
  else
    nl = line.split(":")[1]
    case 
    when line.start_with?("  Starting items:")
      monkeys[monke].items = nl.split(",").collect(&:to_i)
    when line.start_with?("  Operation:")
      monkeys[monke].rawop = nl
    when line.start_with?("  Test:")
      monkeys[monke].test = nl.split(" ")[2].to_i
    when line.start_with?("    If true:")
      monkeys[monke].tc = nl.split(" ")[3].to_i
    when line.start_with?("    If false:")
      monkeys[monke].fc = nl.split(" ")[3].to_i
    else
      raise "not supported"
    end
  end
end

mk = monkeys.keys

20.times do 
mk.each do |mn|
  while !monkeys[mn].items.empty?
    monkeys[mn].inspc += 1
    cw = monkeys[mn].items.shift
    pcw = monkeys[mn].op(cw)
    pcw /= 3
    if (pcw % monkeys[mn].test).eql?(0)
      monkeys[monkeys[mn].tc].items << pcw
    else
      monkeys[monkeys[mn].fc].items << pcw
    end
  end
end
end

puts monkeys.values.collect {|m| m.inspc}.sort.reverse.take(2).inject(1) {|a,c| a=a*c}
