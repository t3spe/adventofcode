gol = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  gol << line.split("")
end

nd = (-1..1).to_a.product((-1..1).to_a).select { |a, b| (a * b).eql?(0) } - [[0, 0]]

def build_grid(c, level, nd)
  5.times do |x|
    5.times do |y|
      next if x.eql?(2) && y.eql?(2)
      c[[level, x, y]] = { cell: [0, 0], neg: [] }
      nd.each do |dx, dy|
        px = x + dx
        py = y + dy
        if px >= 0 && px < 5 && py >= 0 && py < 5
          unless px.eql?(2) && py.eql?(2)
            c[[level, x, y]][:neg] << [level, px, py]
          end
        end
        # special cases
        if px < 0
          c[[level, x, y]][:neg] << [level + 1, 1, 2]
        end
        if py < 0
          c[[level, x, y]][:neg] << [level + 1, 2, 1]
        end
        if px >= 5
          c[[level, x, y]][:neg] << [level + 1, 3, 2]
        end
        if py >= 5
          c[[level, x, y]][:neg] << [level + 1, 2, 3]
        end
      end
      if x.eql?(2) && y.eql?(1)
        5.times { |tx| c[[level, x, y]][:neg] << [level - 1, tx, 0] }
      end
      if x.eql?(2) && y.eql?(3)
        5.times { |tx| c[[level, x, y]][:neg] << [level - 1, tx, 4] }
      end
      if x.eql?(1) && y.eql?(2)
        5.times { |ty| c[[level, x, y]][:neg] << [level - 1, 0, ty] }
      end
      if x.eql?(3) && y.eql?(2)
        5.times { |ty| c[[level, x, y]][:neg] << [level - 1, 4, ty] }
      end
    end
  end
end

c = {}
gen = 200

(-gen).upto(gen).each do |g|
  build_grid(c, g, nd)
end

# write level 0
5.times do |x|
  5.times do |y|
    next if x.eql?(2) && y.eql?(2)
    case gol[x][y]
    when "#"
      c[[0, x, y]][:cell][0] = 1
    when "."
      c[[0, x, y]][:cell][0] = 0
    end
  end
end

# now the show is about to start
cp = 0
gen.times do
  cp = 1 - cp
  c.keys.each do |ck|
    n = 0
    c[ck][:neg].each do |nx|
      if c.key?(nx)
        n += c[nx][:cell][1 - cp]
      end
    end
    # number of neighbours
    if c[ck][:cell][1 - cp].eql?(0)
      c[ck][:cell][cp] = 0
      c[ck][:cell][cp] = 1 if n.eql?(1) || n.eql?(2)
    else
      c[ck][:cell][cp] = 1
      c[ck][:cell][cp] = 0 unless n.eql?(1)
    end
  end
end

# now count bugs
res = c.keys.collect { |ck| c[ck][:cell][cp] }.sum
puts "=" * 80
puts res
