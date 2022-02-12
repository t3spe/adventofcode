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

d = {}
d["e"] = [1, 0, -1]
d["ne"] = [1, -1, 0]
d["nw"] = [0, -1, 1]
d["w"] = [-1, 0, 1]
d["sw"] = [-1, 1, 0]
d["se"] = [0, 1, -1]

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

puts "=" * 80
puts fl.keys.size
