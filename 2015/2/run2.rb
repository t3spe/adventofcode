total = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  d = line.split("x").collect(&:to_i).sort
  r = 2 * d.take(2).sum
  b = d.inject(1) { |a, c| a * c }
  total += (r + b)
end
puts total
