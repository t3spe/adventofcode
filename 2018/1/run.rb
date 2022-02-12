f = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  f += line.to_i
end
puts f
