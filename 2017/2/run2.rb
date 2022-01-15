sum = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  sl = line.split(" ").collect(&:to_i).sort
  sl.combination(2).each do |s, b|
    if b % s == 0
      sum += b / s
      break
    end
  end
end
puts sum
