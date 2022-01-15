require "set"
p = {}

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  src, dests = line.split("<->")
  src = src.to_i
  dests = dests.gsub(",", " ").split(" ").collect(&:to_i)
  p[src] = dests
end

def visit(s, v, p)
  return if v.include?(s)
  v << s
  p[s].each do |n|
    visit(n, v, p)
  end
end

v = Set.new
visit(0, v, p)
puts v.size
