tiles = []
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  rl = line.split("")
  idx = 0
  path = []
  while idx < rl.size
    case rl[idx]
    when "e", "w"
      path << rl[idx]
      idx += 1
    when "n", "s"
      path << "#{rl[idx]}#{rl[idx + 1]}"
      idx += 2
    else
      raise "impossible? #{idx}"
    end
  end
  tiles << path
end

# the right coordinate system makes all the difference
# https://www.redblobgames.com/grids/hexagons/
# cube coord ftw
d = {}
d["e"] = [1, 0, -1]
d["ne"] = [1, -1, 0]
d["nw"] = [0, -1, 1]
d["w"] = [-1, 0, 1]
d["sw"] = [-1, 1, 0]
d["se"] = [0, 1, -1]

# intial iteration
fl = {}
pos = tiles.collect do |tile|
  p = [0, 0, 0]
  tile.each do |dir|
    3.times do |ix|
      p[ix] += d[dir][ix]
    end
  end
  fl[p] ||= 0
  fl[p] += 1
  fl.delete(p) if fl[p].eql?(2)
end

def update(fl, d)
  nfl = {}
  x0, x1 = fl.keys.collect { |k| k[0] }.minmax
  y0, y1 = fl.keys.collect { |k| k[1] }.minmax
  z0, z1 = fl.keys.collect { |k| k[2] }.minmax
  delta = 1
  x0 -= delta
  x1 += delta
  y0 -= delta
  y1 += delta
  z0 -= delta
  z1 += delta
  # go through and update
  x0.upto(x1).each do |x|
    y0.upto(y1).each do |y|
      z0.upto(z1).each do |z|
        next unless [x, y, z].sum.eql?(0)
        cv = 0
        cv = fl[[x, y, z]] if fl.key?([x, y, z])
        ng = 0
        d.values.each do |dir|
          nk = [x + dir[0], y + dir[1], z + dir[2]]
          ng += 1 if fl.key?(nk) && fl[nk].eql?(1)
        end
        case cv
        when 0
          nfl[[x, y, z]] = 0
          nfl[[x, y, z]] = 1 if ng.eql?(2)
        when 1
          nfl[[x, y, z]] = 1
          nfl[[x, y, z]] = 0 if ng.eql?(0) || ng > 2
        end
      end
    end
  end
  # now prune the white tiles
  nfl.select { |k, v| v.eql?(1) }
end

100.times do |iter|
  fl = update(fl, d)
  puts "iter #{iter + 1} => #{fl.keys.size}"
end

puts "=" * 80
puts fl.keys.size
