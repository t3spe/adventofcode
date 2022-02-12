adp = []
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  adp << line.to_i
end

adp.sort!
adp.unshift(0)
adp.push(adp.max + 3)

diffs = {}
(adp.size - 1).times do |idx|
  diffs[adp[idx + 1] - adp[idx]] ||= 0
  diffs[adp[idx + 1] - adp[idx]] += 1
end

puts "=" * 80
puts diffs[1] * diffs[3]
