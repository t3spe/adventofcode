total = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  d = line.split("x").collect(&:to_i).sort
  r = d[0] * d[1]
  r += 2 * d.combination(2).collect { |x, y| x * y }.sum
  total += r
end
puts total
