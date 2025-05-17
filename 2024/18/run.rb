# directions
d = ((-1..1).to_a.product((-1..1).to_a) - [[0,0]]).reject {|a,b| (a.abs+b.abs).eql?(2)}

# grid setup
#sz=7
sz=71
#blimit = 12
blimit = 1024
bt=0
h=Hash.new("#")
sz.times {|x| sz.times {|y| h[[x,y]] = "."} }

def debug(h, sz)
  sz.times do |y|
    sz.times do |x|
      print h[[x,y]]
    end
    print "\n"
  end
end

# this reads the input
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  x, y = line.split(",").map(&:to_i)
  raise "invalid x: #{x}" if x < 0 || x >= sz
  raise "invalid y: #{y}" if y < 0 || y >= sz
  h[[x,y]] = "#"
  bt += 1
  break if bt >= blimit
end


debug(h, sz)
v = {}
q = []
q << [0,0,0]

while !q.empty?
  x, y, c = q.pop
  if v.key?([x,y])
    if v[[x,y]] <= c
      next
    end
  end
  v[[x,y]] = c
  d.each do |dx,dy|
    nx = x + dx
    ny = y + dy
    next if h[[nx,ny]] == "#"
    q << [nx ,ny, c+1]
  end
  q.sort_by! {|a,b,c| -(a+b)}
end

puts v[[sz-1,sz-1]]
