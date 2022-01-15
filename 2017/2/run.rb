sum = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  mm = line.split(" ").collect(&:to_i).minmax
  sum += (mm[1] - mm[0])
end
puts sum
