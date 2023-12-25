require 'set'
m = []

def inside?(m, point)
  y, x = point
  return false if y < 0 || y >= m.size 
  return false if x < 0 || x >= m[0].size 
  return true
end

def move_beam(m, current_point, direction)
  y, x = current_point
  dy, dx = direction
  # return [] unless inside?(m, current_point)
  nx = x + dx
  ny = y + dy
  return [] unless inside?(m, [ny, nx])
  case m[ny][nx]
  when "."
    # nothing changed - keep going
    return[[[ny,nx],direction]]
  when "\\"
    # reflection - swap directions
    return[[[ny,nx],[dx, dy]]]
  when "/"
    return[[[ny,nx],[-dx, -dy]]]
  when "-"
    # keep goign if y is not changing
    return[[[ny,nx],direction]] if dy.eql?(0)
    # now the splitter
    return [
      [[ny, nx], [0, -1]],[[ny, nx], [0, 1]]
    ]
  when "|"
    # keep going if x is not changing
    return[[[ny,nx],direction]] if dx.eql?(0)
    # now the splitter
    return [
      [[ny, nx], [-1, 0]],[[ny, nx], [1, 0]]
    ]
  else
    raise "not supported"
  end
end

def dbg(m)
  m.size.times do |y|
    m[0].size.times do |x|
      print m[y][x]
    end
    print "\n"
  end
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  m << line.split("")
end

v = Set.new
q = []
# seed 
q << [[0,-1],[0,1]]
while !q.empty?
  e = q.shift
  next if v.include?(e)
  v << e
  move_beam(m, e[0], e[1]).each {|ne| q << ne}
end

# remove the seed which is outside of the array
v.delete([[0,-1],[0,1]]) 

# now let's see how many tiles we have energized
puts v.collect(&:first).uniq.size
