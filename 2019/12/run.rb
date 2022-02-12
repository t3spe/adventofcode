moons = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  moons << line.gsub("<", "").gsub(">", "").split(",").collect { |m| m.split("=")[1].to_i } + [0, 0, 0]
end

1000.times do
  # this is one iteration
  # step 1 update the velocities
  moons.combination(2).each do |tmoons|
    3.times do |idx|
      next if tmoons[0][idx].eql?(tmoons[1][idx])
      if tmoons[0][idx] > tmoons[1][idx]
        tmoons[0][idx + 3] -= 1
        tmoons[1][idx + 3] += 1
      else
        tmoons[0][idx + 3] += 1
        tmoons[1][idx + 3] -= 1
      end
    end
  end

  # step 2 update the position
  moons.each do |tmoon|
    3.times do |idx|
      tmoon[idx] += tmoon[idx + 3]
    end
  end
end

moons.each { |m| p m }

energy = moons.collect do |m|
  m[0, 3].collect { |d| d.abs }.sum * m[3, 3].collect { |d| d.abs }.sum
end.sum

puts "=" * 80
puts energy
