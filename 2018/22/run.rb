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

sum = 0
0.upto(tx).each do |x|
  0.upto(ty).each do |y|
    sum += (compute(x, y, tx, ty, g, depth) % 3)
  end
end

puts "=" * 80
puts sum
