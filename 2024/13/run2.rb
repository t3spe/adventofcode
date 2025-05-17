claws = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  if line.start_with?("Button A:")
    claws << {}
    claws[-1][:a] = line.split(":")[1].split(",").collect {|x| x.split("+")[1]}.collect(&:to_i)
  elsif line.start_with?("Button B:")
    claws[-1][:b] = line.split(":")[1].split(",").collect {|x| x.split("+")[1]}.collect(&:to_i)
  elsif line.start_with?("Prize:")
    claws[-1][:prize] = line.split(":")[1].split(",").collect {|x| x.split("=")[1]}.collect(&:to_i).collect {|x| x + 10000000000000}
  end
end

sum = 0
claws.each do |cl|
  dx = cl[:prize][0] * cl[:b][1] - cl[:prize][1] * cl[:b][0]
  dy = cl[:a][0] * cl[:prize][1] - cl[:a][1] * cl[:prize][0]
  d = cl[:a][0] * cl[:b][1] - cl[:a][1] * cl[:b][0]
  next unless (dx % d).eql?(0)
  next unless (dy % d).eql?(0)
  x = dx / d
  y = dy / d
  sum += 3*x + y
end
puts sum