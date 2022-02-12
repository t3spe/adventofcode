moons = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  moons << line.gsub("<", "").gsub(">", "").split(",").collect { |m| m.split("=")[1].to_i } + [0, 0, 0]
end

cycle = Array.new(3) { nil }
iter = 0

# the stupid trick for this one is that the axis are independent
#   and we can figure out the periodicity per axis (x,y,z)

startP = []
# collect all the x, y and z coordinates
3.times do |idx|
  startP << moons.collect { |m| [m[idx], m[idx + 3]] }
end

while cycle.include?(nil)
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
  iter += 1

  # now it's time to check for equality

  currentP = []
  # collect all the x, y and z coordinates
  3.times do |idx|
    currentP << moons.collect { |m| [m[idx], m[idx + 3]] }
  end

  3.times do |idx|
    next unless cycle[idx].nil?
    cycle[idx] = iter if currentP[idx].eql?(startP[idx])
  end
end

puts cycle.inspect

require "prime"
# now we need to figure out the lcm
acc = {}
3.times do |idx|
  Prime.prime_division(cycle[idx]).each do |n, pw|
    acc[n] ||= pw
    acc[n] = [acc[n], pw].max
  end
end

res = Prime.int_from_prime_division(acc.to_a)
puts "=" * 80
puts res.inspect
