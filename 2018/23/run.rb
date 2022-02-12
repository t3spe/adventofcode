botz = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  botz << line.gsub("<", "").split(">").collect { |c| c.split("=")[1] }.collect { |c| c.split(",").collect(&:to_i) }.flatten
end

botz = botz.sort_by { |x, y, z, r| -r }
in_range = botz.select do |b|
  d = 0
  3.times { |i| d += (b[i] - botz[0][i]).abs }
  d <= botz[0][3]
end.size

puts "=" * 80
puts in_range
