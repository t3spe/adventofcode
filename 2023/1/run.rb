score = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  ls = line.split("").select {|x| ('0'..'9').to_a.include?(x) }
  score += "#{ls.first}#{ls.last}".to_i
end
puts score
