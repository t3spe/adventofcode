l1 = []
l2 = []
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  a, b = line.split(" ").collect(&:to_i)
  l1 << a
  l2 << b
end
l1.sort!
l2.sort!
d = 0

l1.size.times do |sz|
  d += (l1[sz] - l2[sz]).abs
end
puts d
