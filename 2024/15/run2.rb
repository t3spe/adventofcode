require 'set'

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


def debug(h, mx, my, f)
  return #nodebug 
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

def find_boxes(h, px, py, dx, dy)
    seen = Set.new
    vbox = []
    vbox << [px, py]
    while !vbox.empty?
        cx, cy = vbox.shift
        next if seen.include?([cx,cy])
        seen << [cx, cy] # mar it as seen
        nx, ny = cx + dx, cy + dy
        next if h[[nx,ny]].eql?(".")
        raise "wall" if h[[nx,ny]].eql?("#")
        vbox << [nx, ny]
        if dx.eql?(0)
            vbox << [nx+1, ny] if h[[nx,ny]].eql?("[")
            vbox << [nx-1, ny] if h[[nx,ny]].eql?("]")    
        end
    end 
    seen
end

File.readlines("input2.txt").collect(&:chomp).each do |line|
  mode = 2 if line.empty?
  if mode.eql?(1)
    line2 = line.split("").collect do |x|
        case x 
        when "#"
            "##"
        when "O"
            "[]"
        when "."
            ".."
        when "@"
            "@."
        else
            raise "invalid"
        end
    end.join("")
    
    line2.split("").each_with_index do |e,i|
      mx = [i+1, mx].max
      f = [i,cl] if e.eql?("@")
      h[[i,cl]] = "."
      h[[i,cl]] = e if e.eql?("#") || e.eql?("[") || e.eql?("]")
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
puts "-"*20


moves.each do |m|
    # puts "Move: #{m}"
    dx, dy = mmap[m]
    begin
        uh = Marshal.load(Marshal.dump(h))
        seen = find_boxes(h, f[0], f[1], dx, dy)
        # debug(h,mx,my,f)  
        # puts seen.inspect

        cp = {}
        seen.each do |ux,uy|
            cp[[ux+dx, uy+dy]] = h[[ux, uy]]
        end
        # puts cp.inspect
        seen.each do |ux,uy|
            h[[ux, uy]] = "."
        end
        cp.each do |kk,vv| 
            raise "wall!" if h[kk].eql?("#")
            h[kk] = vv 
        end

        f[0]+=dx
        f[1]+=dy
        debug(h,mx,my,f) 
    rescue StandardError => se
        # puts se.message
        # need to rollback state when the move is invalid
        h = Marshal.load(Marshal.dump(uh))
        # puts "...invalid"
    end
    # puts "-"*20
end

debug(h,mx,my,f)  
puts h.select {|k,v| v.eql?("[")}.keys.collect {|x,y| x + y*100}.sum
