c2 = 0
c3 = 0

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  h = {}
  line.split("").sort.each do |l|
    h[l] ||= 0
    h[l] += 1
  end
  c2 += 1 if h.values.include?(2)
  c3 += 1 if h.values.include?(3)
end

puts c2 * c3
