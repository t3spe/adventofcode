h = {}

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  c, o = line.split(")")
  h[c] ||= []
  h[o] ||= []
  h[c] << o
end

def compute(h, root, depth = 0)
  return depth if h[root].empty?
  depth + h[root].collect { |o| compute(h, o, depth + 1) }.sum
end

# now find the root
roots = h.keys - h.values.flatten

res = roots.collect do |root|
  compute(h, root)
end.sum

puts "=" * 80
puts res
