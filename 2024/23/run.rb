require 'set'
g = {}

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  a,b = line.split("-")
  g[a]||=Set.new
  g[b]||=Set.new
  g[a] << b
  g[b] << a
end

combos = Set.new

g.keys.each do |n1|
  g[n1].each do |n2|
    (g[n1] & g[n2]).each do |n3|
      combos << [n1, n2, n3].sort if [n1,n2,n3].any? {|n| n.start_with?("t") }
    end
  end
end

puts combos.size