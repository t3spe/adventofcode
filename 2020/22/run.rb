pz = nil
decks = [[], []]

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  if line.include?("Player 1")
    pz = 0
  elsif line.include?("Player 2")
    pz = 1
  else
    decks[pz] << line.to_i
  end
end

while !decks.any? { |x| x.empty? }
  p0 = decks[0].shift
  p1 = decks[1].shift
  if p0 > p1
    decks[0] << p0
    decks[0] << p1
  else
    decks[1] << p1
    decks[1] << p0
  end
end

wdeck = decks[0]
wdeck = decks[1] if wdeck.empty?
wdeck = wdeck.reverse
sum = 0

wdeck.size.times do |idx|
  sum += wdeck[idx] * (idx + 1)
end

puts "=" * 80
puts sum
