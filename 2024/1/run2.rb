l1 = {}
l2 = {}
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  a, b = line.split(" ").collect(&:to_i)
  l1[a]||=0
  l1[a]+=1
  l2[b]||=0
  l2[b]+=1
end

d = 0
l1.keys.each do |k|
    d += k * l1[k] * l2[k] if l2.key?(k)
end
puts d
