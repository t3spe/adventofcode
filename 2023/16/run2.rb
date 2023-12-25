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

def compute_energized_from(m, start_tile, direction)
    v = Set.new
    q = []
    # seed 
    fs0 = start_tile[0] - direction[0]
    fs1 = start_tile[1] - direction[1]

    q << [[fs0,fs1],direction]
    while !q.empty?
      e = q.shift
      next if v.include?(e)
      v << e
      move_beam(m, e[0], e[1]).each {|ne| q << ne}
    end
    
    # remove the seed which is outside of the array
    v.delete([[fs0,fs1],direction])
    
    # now let's see how many tiles we have energized
    return v.collect(&:first).uniq.size
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  m << line.split("")
end

compute_all = []
m.size.times do |my|
    compute_all << compute_energized_from(m, [my, 0], [0, 1])
    compute_all << compute_energized_from(m, [my, m.size-1], [0, -1])
end

m[0].size.times do |mx|
    compute_all << compute_energized_from(m, [0, mx], [1, 0])
    compute_all << compute_energized_from(m, [m[0].size-1, mx], [-1, 0])
end

puts compute_all.max

