require "set"
m = []
dd = (-1..1).to_a.product((-1..1).to_a).select {|a,b| (a.abs + b.abs).eql?(1)}

def dbg(m)
  puts "-"*20
  m.size.times do |y|
    m[0].size.times do |x|
      print m[y][x]
    end
    print "\n"
  end
end

def find_start(m)
  m.size.times do |y|
    m[0].size.times do |x|
      return [y,x] if m[y][x].eql?("S")
    end
  end
end

def inside?(m, point)
  y, x = point
  return false if y < 0 || y >= m.size 
  return false if x < 0 || x >= m[0].size 
  return true
end

def get_neighbours(m, pos, dd)
  rv = []
  return rv unless inside?(m, pos) && m[pos[0]][pos[1]].eql?(".")
  dd.each do |d0, d1|
    npos = [pos[0]+d0, pos[1]+d1]
    next unless inside?(m, npos) && m[npos[0]][npos[1]].eql?(".")
    rv << npos
  end
  return rv
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  m << line.split("")
end

dbg(m)
st = find_start(m)
m[st[0]][st[1]] = "."
dbg(m)

steps = 0
target_steps = 64
visited = Set.new
visited << st

while steps < target_steps
  new_visited = Set.new
  visited.each do |v|
    get_neighbours(m, v, dd).each do |nv|
      new_visited << nv
    end
  end
  visited = new_visited
  steps += 1
end

puts visited.inspect
puts "-" * 20
puts visited.size