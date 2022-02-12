g = {}
y = 0
z = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  line.split("").each_with_index do |e, x|
    g[[x, y, z]] = 1 if e.eql?("#")
  end
  y += 1
end

# delta by dimension for neighbours
neg = (-1..1).to_a.product((-1..1).to_a).product((-1..1).to_a).collect { |e| e.flatten } - [[0, 0, 0]]

def prune_grid(g)
  gk = g.keys
  gk.each do |k|
    g.delete(k) if g.key?(k) && g[k].eql?(0)
  end
  g
end

def compute_bounds(g)
  b = []
  3.times do |idx|
    b += g.keys.collect { |k| k[idx] }.minmax
  end
  expand = 2
  b.size.times do |dm|
    if dm % 2 == 0
      b[dm] -= expand
    else
      b[dm] += expand
    end
  end
  b
end

def update_grid(g, neg)
  ng = {}
  x0, x1, y0, y1, z0, z1 = compute_bounds(g)
  x0.upto(x1).each do |x|
    y0.upto(y1).each do |y|
      z0.upto(z1).each do |z|
        curr = 0
        curr = g[[x, y, z]] if g.key?([x, y, z])
        # now see how many neg we have
        active_neg = neg.collect do |n|
          nc = [x + n[0], y + n[1], z + n[2]]
          if g.key?(nc) && g[nc].eql?(1)
            1
          else
            0
          end
        end.sum
        # no update the field in the new state
        case curr
        when 0
          ng[[x, y, z]] = 0
          ng[[x, y, z]] = 1 if active_neg.eql?(3)
        when 1
          ng[[x, y, z]] = 0
          ng[[x, y, z]] = 1 if active_neg.eql?(2) || active_neg.eql?(3)
        end
      end
    end
  end
  prune_grid(ng)
end

6.times do |cyc|
  g = update_grid(g, neg)
end

puts "=" * 80
puts g.keys.size
