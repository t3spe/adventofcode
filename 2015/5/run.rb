def nice?(s)
  v = 0
  s.size.times do |c|
    v += 1 if ["a", "e", "i", "o", "u"].include?(s[c])
  end
  return false unless v >= 3
  dd = false
  (s.size - 1).times do |c|
    dd = true if s[c].eql?(s[c + 1])
    return false if ["ab", "cd", "pq", "xy"].include?(s[c, 2])
  end
  return dd.eql?(true)
end

cnt = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  cnt += 1 if nice?(line)
end
puts cnt
