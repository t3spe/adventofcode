sum = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  h, c = line.split(":")
  r0, r1 = c.split("|").collect {|x| x.split(" ")}
  sum += (1 << (r0 & r1).size) >> 1
end
puts sum
