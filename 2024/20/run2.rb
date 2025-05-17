h={}
mx=0
my=0
sp=nil
ep=nil

def debug(h, mx, my)
  my.times do |y|
    mx.times do |x|
      print h[[x,y]]
    end
    print "\n"
  end
end

def find_path(h, start, endp)
  q = [[start, 1, [start]]]
  visited = {}
  while !q.empty?
    p, steps, cpath = q.shift
    return [steps, cpath] if p == endp
    next if visited[p]
    visited[p] = true
    [[0,1],[1,0],[0,-1],[-1,0]].each do |dx, dy|
      np = [p[0]+dx, p[1]+dy]
      next if !h.key?(np) || h[np] == "#"
      if h[np] == "." || h[np] == "E"
        npath = cpath.dup 
        npath << np
        q << [np, steps+1, npath] 
      end
    end
  end
  nil
end

def distance(a, b)
  (a[0]-b[0]).abs + (a[1]-b[1]).abs
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  line.split("").each_with_index do |c,i|
    h[[i, my]] = c
    if c == "S"
      sp = [i, my]
    elsif c == "E"
      ep = [i, my]
    end
    mx = i+1 if i+1 > mx
  end
  my += 1
end

# parameters
cheat = 20
# saved = 50
saved = 100

# bookkeeping
count = 0
ch = {}

s, p = find_path(h, sp, ep)

s.times do |posa|
  posa.upto(s-1) do |posb|
    # now compute the distance between the two points
    d = distance(p[posa], p[posb])
    if (d <= cheat) && (posb-posa-d >= saved) 
      count += 1
      svd = posb-posa-d
      ch[svd]||= []
      ch[svd] << [p[posa], p[posb]]
    end
  end
end

# ch.keys.sort.each do |k|  
#   puts "#{ch[k].size} (#{k}) " #=> #{ch[k].inspect}"
# end

puts count
