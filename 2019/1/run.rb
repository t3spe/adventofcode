sum = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  sum += (line.to_i / 3 - 2)
end
puts sum
