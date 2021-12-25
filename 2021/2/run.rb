depth = 0
pos = 0
depth = 0
File.readlines("input2.txt").collect do |line|
  c = line.chomp.split(" ")
  d = c[1].to_i
  case c[0]
  when "up"
    depth -= d
  when "down"
    depth += d
  when "forward"
    pos += d
  else
    raise "not supported"
  end
end

puts depth * pos
