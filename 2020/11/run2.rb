g = {}
y = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  line.split("").each_with_index do |e, i|
    if e.eql?("L")
      g[[i, y]] = { cell: [0, 0], n: [], t: 1 }
    else
      g[[i, y]] = { cell: [0, 0], t: 0 }
    end
  end
  y += 1
end

neg = (-1..1).to_a.product((-1..1).to_a) - [[0, 0]]

def evolve(g, cp, neg)
  mutated = false
  # this only processes seats
  g.keys.select { |k| g[k][:t].eql?(1) }.each do |k|
    cnt = 0
    neg.each do |n|
      d = 1
      px = k[0] + d * n[0]
      py = k[1] + d * n[1]
      while g.key?([px, py]) && g[[px, py]][:t].eql?(0)
        d += 1
        px = k[0] + d * n[0]
        py = k[1] + d * n[1]
      end
      cnt += 1 if g.key?([px, py]) && g[[px, py]][:cell][1 - cp].eql?(1)
    end
    # have computed the neighbors
    case g[k][:cell][1 - cp]
    when 0
      if cnt.eql?(0)
        g[k][:cell][cp] = 1
        mutated = true
      else
        g[k][:cell][cp] = g[k][:cell][1 - cp]
      end
    when 1
      if cnt >= 5
        g[k][:cell][cp] = 0
        mutated = true
      else
        g[k][:cell][cp] = g[k][:cell][1 - cp]
      end
    end
  end
  mutated
end

cp = 0
while evolve(g, cp, neg)
  cp = 1 - cp
end

res = g.keys.collect { |k| g[k][:cell][cp] }.sum
puts "=" * 80
puts res
