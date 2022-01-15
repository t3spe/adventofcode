require "set"

banks = []
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  banks = line.split(" ").collect(&:to_i)
end

count = 0
seen = Set.new
key = banks.to_s

while !seen.include?(key)
  seen << key
  max = banks.max
  maxi = banks.index(max)
  banks[maxi] = 0

  inca = 0
  while max >= banks.size
    inca += 1
    max -= banks.size
  end

  banks.size.times do |c|
    banks[c] += inca
  end

  max.times do
    maxi += 1
    maxi %= banks.size
    banks[maxi] += 1
  end

  key = banks.to_s
  count += 1
end

puts count
