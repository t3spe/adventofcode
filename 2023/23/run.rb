require 'set'
m = []
dd = (-1..1).to_a.product((-1..1).to_a).select {|a,b| (a.abs + b.abs).eql?(1)}

def uphill(dd)
  case dd
  when [-1, 0]
    return "v"
  when [1, 0]
    return "^"
  when [0, -1]
    return ">"
  when [0, 1]
    return "<"
  else 
    raise "invalid direction"
  end
end

def downhill(dv)
  case dv
  when "^"
    return [-1,0]
  when "v"
    return [1,0]
  when "<"
    return [0,-1]
  when ">"
    return [0, 1]
  else 
    return [0,0]
  end
end

def dbg(m)
  puts "-"*20
  m.size.times do |y|
    m[0].size.times do |x|
      print m[y][x]
    end
    print "\n"
  end
end

def dbgv(m,v)
  puts "-"*20
  m.size.times do |y|
    m[0].size.times do |x|
      if v.include?([y,x])
        print "O"
      else
        print m[y][x]
      end
    end
    print "\n"
  end
end

def find_start(m)
  m.size.times do |y|
    m[0].size.times do |x|
      return [y,x] if m[y][x].eql?(".")
    end
  end
end

def find_end(m)
  found_end = nil
  m.size.times do |y|
    m[0].size.times do |x|
      found_end = [y,x] if m[y][x].eql?(".")
    end
  end
  return found_end
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  m << line.split("")
end

sp = find_start(m)
se = find_end(m)
best = 0
visited = Set.new

def walk(location, steps, visited, m, dd, c)
  visited << location
  c[location] ||= []
  c[location] << steps
  dvv = downhill(location)
  if dvv.eql?([0,0])
    dvv = dd
  else
    dvv = [dvv]
  end
  dvv.each do |dp|
    npos = [location[0]+dp[0], location[1] + dp[1]]
    next if visited.include?(npos) 
    next if npos[0] < 0 || npos[0] >= m.size
    next if npos[1] < 0 || npos[1] >= m[0].size
    # cannot go through walls
    next if m[npos[0]][npos[1]].eql?("#") 
    # cannot go uphil
    next if m[npos[0]][npos[1]].eql?(uphill(dp)) 
    walk(npos, steps+1, visited, m, dd, c)
  end
  visited.delete(location)
end

c = {}
walk(sp, 0, visited, m, dd, c)

# display solution
puts c[se].max