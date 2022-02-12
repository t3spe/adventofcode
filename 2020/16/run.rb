rules = []
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
    ranges = line.split(": ")[1].split(" or ").collect { |x| x.split("-").collect(&:to_i) }
    rules += ranges
  when 1
    your_t = line.split(",").collect(&:to_i)
  when 2
    nearby_t += [line.split(",").collect(&:to_i)]
  end
end

res = nearby_t.collect do |t|
  t - t.select do |te|
    rules.any? { |s, e| te >= s && te <= e }
  end
end.flatten.sum

puts "=" * 80
puts res
