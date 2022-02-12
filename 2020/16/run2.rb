rules = {}
your_t = []
nearby_t = []
pzone = 0

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  if line.include?("your ticket")
    pzone = 1
    next
  end
  if line.include?("nearby tickets")
    pzone = 2
    next
  end
  case pzone
  when 0
    field = line.split(": ")[0]
    ranges = line.split(": ")[1].split(" or ").collect { |x| x.split("-").collect(&:to_i) }
    rules[field] = ranges
  when 1
    your_t = line.split(",").collect(&:to_i)
  when 2
    nearby_t += [line.split(",").collect(&:to_i)]
  end
end

# figure out which tickets are valid
valid_t = nearby_t.select do |t|
  t.select do |te|
    rules.values.flatten(1).any? { |s, e| te >= s && te <= e }
  end.size.eql?(t.size)
end

guess = {}

# now try to bucket the fields
valid_t.each do |ticket|
  ticket.each_with_index do |t, i|
    poss_match = []
    rules.each do |k, v|
      poss_match << k if v.any? { |s, e| t >= s && t <= e }
    end
    guess[i] ||= []
    guess[i] << poss_match
  end
end

# now intersect all poss values
guess.keys.each do |k|
  m = rules.keys
  guess[k].each { |p| m = m & p }
  guess[k] = m
end

conv = {}

while guess.keys.size > 0
  ov = guess.select { |k, v| v.size.eql?(1) }.keys
  ov.each do |onv|
    cv = guess[onv].first
    conv[cv] = onv
    # now go though everythign and remove the reference
    guess.keys.each do |k|
      guess[k] = guess[k] - [cv]
    end
    # finally remove the key
    guess.delete(onv)
  end
end

# now process my ticket
res = conv.select { |k, v| k.include?("departure") }.values.inject(1) { |a, c| a *= your_t[c] }
puts "=" * 80
puts res
