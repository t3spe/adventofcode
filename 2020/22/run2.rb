require "set"
require "digest"

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

def playgame(decks)
  history = Set.new
  while !decks.any? { |x| x.empty? }
    curr = decks.hash
    return [:p0, decks[0]] if history.include?(curr)
    history << curr
    p0 = decks[0].shift
    p1 = decks[1].shift
    result = if decks[0].size >= p0 && decks[1].size >= p1
        playgame([decks[0].take(p0), decks[1].take(p1)]).first
      else
        p0 > p1 ? :p0 : :p1
      end
    if result.eql?(:p0)
      decks[0] << p0
      decks[0] << p1
    else
      decks[1] << p1
      decks[1] << p0
    end
  end
  return decks[1].empty? ? [:p0, decks[0]] : [:p1, decks[1]]
end

wdeck = playgame(decks).last.reverse
sum = 0

wdeck.size.times do |idx|
  sum += wdeck[idx] * (idx + 1)
end

puts "=" * 80
puts sum
