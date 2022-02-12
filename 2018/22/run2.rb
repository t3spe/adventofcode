require "set"

def compute(x, y, tx, ty, g, depth)
  return g[[x, y]] if g.key?([x, y])
  gi = 0
  if x.eql?(0) && y.eql?(0)
    gi = 0
  elsif x.eql?(tx) && y.eql?(ty)
    gi = 0
  elsif y.eql?(0)
    gi = x * 16807
  elsif x.eql?(0)
    gi = y * 48271
  else
    gi = compute(x - 1, y, tx, ty, g, depth) * compute(x, y - 1, tx, ty, g, depth)
  end
  g[[x, y]] = (gi + depth) % 20183
  return g[[x, y]]
end

g = {}
# tx, ty = 10, 10
# depth = 510

tx, ty = 13, 734
depth = 7305

0.upto(2 * tx).each do |x|
  0.upto(2 * ty).each do |y|
    compute(x, y, tx, ty, g, depth)
  end
end

# now update to hold erosion level
0.upto(2 * tx).each do |x|
  0.upto(2 * ty).each do |y|
    g[[x, y]] %= 3
  end
end

cost = {}
cost[[tx, ty]] = { t: 0, c: 7 }
q = [[tx, ty]]
neg = (-1..1).to_a.product((-1..1).to_a).select { |a, b| (a * b).eql?(0) } - [[0, 0]]

iter = 0
while !q.empty?
  iter += 1
  print "." if iter % 1000 == 0
  curr = q.shift
  neg.each do |n|
    n0 = curr[0] + n[0]
    n1 = curr[1] + n[1]
    next unless g.key?([n0, n1]) # this is our out of range detector
    cost[[n0, n1]] ||= {} # same costs if it does not exist
    before = cost[[n0, n1]].dup

    source_tools = []
    case g[[n0, n1]]
    when 0
      source_tools = [:c, :t]
    when 1
      source_tools = [:c, :n]
    when 2
      source_tools = [:t, :n]
    end
    dest_tools = cost[curr].keys
    int_tools = source_tools & dest_tools
    next unless int_tools.size > 0

    source_tools.each do |st|
      curr_cost = cost[[n0, n1]][st]
      curr_cost ||= Float::INFINITY
      if int_tools.include?(st)
        cost[[n0, n1]][st] = [curr_cost, cost[curr][st] + 1].min
      else
        cost[[n0, n1]][st] = [curr_cost, cost[curr][int_tools[0]] + 8].min
      end
    end
    after = cost[[n0, n1]].dup
    unless before.eql?(after)
      q << [n0, n1]
    end
  end
end

print "\n"
puts "looked at #{iter} locations"
puts "=" * 80

puts cost[[0, 0]][:t].inspect
