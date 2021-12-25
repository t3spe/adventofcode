depth = 0
pos = 0
aim = 0
File.readlines("input2.txt").collect do |line|
  c = line.chomp.split(" ")
  d = c[1].to_i
  case c[0]
  when "up"
    aim -= d
  when "down"
    aim += d
  when "forward"
    pos += d
    depth += aim * d
  else
    raise "not supported"
  end
end

puts depth * pos
