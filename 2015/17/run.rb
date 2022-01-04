store = 150
ways = 0

c = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  c << line.to_i
end

c.size.times do |p|
  ways = c.combination(p).select { |p1| p1.sum.eql?(store) }.size
  break if ways > 0
end

puts ways
