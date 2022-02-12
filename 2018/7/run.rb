h = {}
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  before, step = line.split(" ").each_with_index.select { |e, i| [1, 7].include?(i) }.collect { |x| x[0] }
  h[before] ||= []
  h[step] ||= []
  h[step] << before
end

resolve_order = []

# assumes we can solve this (ie no circular deps?)
while h.size > 0
  nodes = h.select { |k, v| v.empty? }.keys
  node = nodes.sort.first
  resolve_order << node
  h.values.each { |v| v.delete(node) if v.include?(node) }
  h.delete(node)
end

puts resolve_order.join("")
