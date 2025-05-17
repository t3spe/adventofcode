mode = 1
h = {}
f = [nil,nil]
cl = 0
mx = 0
mmap = {
  "^" => [0,-1],
  "v" => [0,1],
  "<" => [-1,0],
  ">" => [1,0]
}
moves = []

def can_move?(h, x, y, m, mmap)
  d = mmap[m]
  cx, cy = x, y
  while h.key?([cx,cy])
    return false unless h.key?([cx+d[0], cy+d[1]])
    return false if h[[cx+d[0], cy+d[1]]].eql?("#")
    return [d,[x,y],[x+d[0], y+d[1]],[cx+d[0], cy+d[1]]] if h[[cx+d[0], cy+d[1]]].eql?(".")
    # no success. move to the next position
    cx += d[0]
    cy += d[1]
  end
  # we hit the edge. we cannot move
  return false
end


def debug(h, mx, my, f)
  my.times do |yy|
    mx.times do |xx|
      if xx.eql?(f[0]) && yy.eql?(f[1])
        print "@"
      else
      raise "missing #{xx},#{yy}" unless h.key?([xx,yy])
      print h[[xx,yy]]
      end
    end
    puts ""
  end
  
end

File.readlines("input2.txt").collect(&:chomp).each do |line|
  mode = 2 if line.empty?
  if mode.eql?(1)
    line.split("").each_with_index do |e,i|
      mx = [i+1, mx].max
      f = [i,cl] if e.eql?("@")
      h[[i,cl]] = "."
      h[[i,cl]] = e if e.eql?("#") || e.eql?("O")
    end
    cl += 1
  else
    line.split("").each do |mm|
      raise "invalid move #{mm}" unless mmap.keys.include?(mm)
      moves << mm
    end
  end
end
my = cl

debug(h,mx,my,f)

puts f.inspect

# now perform the moves
moves.each do |m|
  r = can_move?(h, f[0], f[1], m, mmap)
  puts "move #{m} => #{r}"
  next if r.eql?(false)
  puts "processing..."
  cd, cf, ns, ne = r
  unless ns[0].eql?(ne[0]) && ns[1].eql?(ne[1])
    # swap
    v1 = h[ns]
    h[ns] = h[ne]
    h[ne] = v1
  end 
  # move the pointer 
  #f = ns
  h[f] = "."
  f[0] = ns[0]
  f[1] = ns[1]

  #debug(h,mx,my,f)  
end

puts h.select {|k,v| v.eql?("O")}.keys.collect {|x,y| x + y*100}.sum



