cnt = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  d = line.inspect.size - line.size
  cnt += d
end

puts cnt
