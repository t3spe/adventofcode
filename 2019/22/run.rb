deck_size = 10007
deck = []
deck_size.times do |c|
  deck << c
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  rl = line.split(" ")
  p = rl[-1].to_i
  if line.include?("cut")
    deck = deck.rotate(p)
  elsif line.include?("deal with increment")
    ndeck = Array.new(deck_size) { -1 }
    spos = 0
    ndeck.size.times do |idx|
      ndeck[spos] = deck[idx]
      spos += p
      spos %= ndeck.size
    end
    deck = ndeck
  elsif line.include?("deal into new stack")
    deck = deck.reverse
  else
    raise "unknown instr"
  end
end

puts "=" * 80
puts deck.index(2019)
