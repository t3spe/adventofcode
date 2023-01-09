require "set"
h={}
m = 0

def dbg_print(h)
  return 
  sx, ex = h.keys.collect {|k| k[0]}.minmax
  sy, ey = h.keys.collect {|k| k[1]}.minmax

  sy.upto(ey).each do |y|
    sx.upto(ex).each do |x|
      if h.key?([x,y]) && !h[[x,y]].nil?
        print h[[x,y]]
      else
        print " "
      end
    end
    print "\n"
  end
  print "\n"
end

def move_points(bs, dir, mex, mey)
  d = [0,0]
  case dir
  when "^"
    d = [0,-1]
  when ">"
    d = [1, 0]
  when "<"
    d = [-1, 0]
  when "v"
    d = [0, 1]
  else 
    raise "unknown direction #{dir}"
  end

  nh = {}
  bs.select {|k,v| v.eql?("#")}.keys.each do |k|
    nh[[(k[0]+d[0]) % mex, (k[1]+d[1]) % mey]] = "#"
  end
  nh
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  line.split("").each_with_index { |e,i| h[[i, m]]=e }
  m+=1
end

_, mx = h.keys.collect {|k| k[0]}.minmax
_, my = h.keys.collect {|k| k[1]}.minmax
neg = (-1..1).to_a.product((-1..1).to_a).select {|x,y| x.abs+y.abs<2}
puts "maxx: #{mx} maxy: #{my}"

b = {}

# now split the blizzards
(my-1).times do |ry|
  (mx-1).times do |rx|
    y = ry+1
    x = rx+1
    s = h[[x,y]]
    next if s.eql?(".")
    b[s]||={}
    b[s][[rx,ry]] = "#"
    h[[x,y]] = "."
  end
end

def get_blizzard(count, mx, my, memo)
  return memo[count] if memo.key?(count)
  (count+1).times do |cnt|
    next if memo.key?(cnt)
    nb, blizz = blizzard_evolve(memo[cnt-1][:bz], mx, my)
    memo[cnt]||={}
    memo[cnt][:blizz] = blizz
    memo[cnt][:bz]=nb
  end
  return memo[count]
end

def blizzard_evolve(bz, mx, my)
  mk = cpph(bz)
  all_blizzards = {}
  bz.each do |k,v|
    bz[k] = move_points(bz[k], k, mx-1, my-1)
    bz[k].select {|k,v| v.eql?("#")}.keys.each do |x,y|
      all_blizzards[[x+1,y+1]] = "#"
    end
  end
  [bz, all_blizzards]
end

start_point = h.select {|k,v| k[1].eql?(0) && !v.eql?("#")}.keys.first
end_point = [ h.select {|k,v| k[1].eql?(my) && !v.eql?("#")}.keys.first ]
end_point << start_point 
end_point << end_point[0]

puts end_point.inspect

def cpph(orig)
  Marshal.load(Marshal.dump(orig))
end

ho = cpph(h)
seen = Set.new
mi = 0
memo={}
memo[-1]||={}
memo[-1][:bz] = b
hcmemo={}

vq = [[start_point, 0]] # state is the point, iteration, and state of blizzards 
while !vq.empty?
  # vq = vq.sort_by {|p, iter| ((p[0] - end_point[0]).abs + (p[1] - end_point[1]).abs)}
  curr_point, iter = vq.shift
  comp = [curr_point, iter]
  if mi < iter
    mi = iter
    print "#{mi}."
  end
  next if seen.include?(comp)
  seen << comp
  # puts "#{curr_point} @ #{iter}"
  if curr_point.eql?(end_point.first)
    if end_point.size.eql?(1)
        puts ""
        puts iter
        exit 0
    end
    # remove the endpoint and clear the queue
    end_point.shift
    vq = []
  end

  blizz = get_blizzard(iter, mx, my, memo)[:blizz]
  hc = nil
  if hcmemo.key?(iter)
    hc = hcmemo[iter]
  else
    hc = cpph(ho)
    blizz.each do |k,v|
      next unless v.eql?("#")
      hc[k] = "#"
    end
  end
  # now we generated the next config, let's start looking at the neighbours
  neg.each do |dx, dy|
    cx = curr_point[0]+dx
    cy = curr_point[1]+dy
    cp = [cx, cy]
    next unless hc.key?(cp) && hc[cp].eql?(".")
    vq << [cp, iter+1]
  end
end