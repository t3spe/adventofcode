g = {}
y = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  line.split("").each_with_index do |e, i|
    if e.eql?("L")
      g[[i, y]] = { cell: [0, 0], n: [] }
    end
  end
  y += 1
end

neg = (-1..1).to_a.product((-1..1).to_a) - [[0, 0]]
g.keys.each do |k|
  neg.each do |n|
    px = k[0] + n[0]
    py = k[1] + n[1]
    g[k][:n] << [px, py] if g.key?([px, py])
  end
end

def evolve(g, cp)
  mutated = false
  g.keys.each do |k|
    cnt = 0
    g[k][:n].each do |n|
      cnt += g[n][:cell][1 - cp]
    end
    case g[k][:cell][1 - cp]
    when 0
      if cnt.eql?(0)
        g[k][:cell][cp] = 1
        mutated = true
      else
        g[k][:cell][cp] = g[k][:cell][1 - cp]
      end
    when 1
      if cnt >= 4
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
while evolve(g, cp)
  cp = 1 - cp
end

res = g.keys.collect { |k| g[k][:cell][cp] }.sum
puts "=" * 80
puts res
