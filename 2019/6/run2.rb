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

def explore(h, root, target, path, acc)
  if root.eql?(target)
    path.push(target)
    acc << path.dup
    path.pop
  else
    path.push(root)
    h[root].each do |ch|
      explore(h, ch, target, path, acc)
    end
    path.pop
  end
end

# now find the root
roots = h.keys - h.values.flatten

acc = []
explore(h, roots.first, "YOU", [], acc)
path_you = acc.first

acc = []
explore(h, roots.first, "SAN", [], acc)
path_san = acc.first

path_common = path_you & path_san
res = (path_you - path_common).size + (path_san - path_common).size - 2

puts "=" * 80
puts res.inspect
