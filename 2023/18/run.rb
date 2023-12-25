require 'set'
h = {}
pos = [0,0]
h[pos.dup] = "#"

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  dir, len, color = line.split(" ")
  len = len.to_i
  d = nil
  case dir 
  when "U"
    d = [0,-1]
  when "D"
    d = [0,1]
  when "L"
    d = [-1,0]
  when "R"
    d = [1,0]
  else 
    raise "unk direction"
  end
  len.times do
    pos[0] += d[0]
    pos[1] += d[1]
    h[pos.dup] = "#"
  end
end

x0, x1 = h.keys.collect {|k| k[0]}.minmax
y0, y1 = h.keys.collect {|k| k[1]}.minmax
pd = (-1..1).to_a.product((-1..1).to_a).select {|a,b| (a.abs + b.abs).eql?(1)}

pc = Set.new
x0.upto(x1).each do |xe|
  pc << [xe,y0] unless h.key?([xe,y0])
  pc << [xe,y1] unless h.key?([xe,y1])
end
y0.upto(y1).each do |ye|
  pc << [x0,ye] unless h.key?([x0,ye])
  pc << [x1,ye] unless h.key?([x1,ye])
end

def flood_fill(h, pii, x0, y0, x1, y1, pd)
  q = []
  q << pii
  while !q.empty?
    p = q.shift
    next if p[0] < x0 || p[0] > x1
    next if p[1] < y0 || p[1] > y1
    next if h.key?(p) && h[p].eql?("#")
    next if h.key?(p) && h[p].eql?(".")
    h[p] = "."
    pd.each do |pd0,pd1|
      q << [p[0]+pd0, p[1]+pd1]
    end
  end
end

pc.each do |peg|
  flood_fill(h, peg, x0, y0, x1, y1, pd)
end

x0.upto(x1).each do |xe|
  y0.upto(y1).each do |ye|
    h[[xe,ye]] = "#" unless h.key?([xe,ye])
  end
end

puts h.values.select {|v| v.eql?("#")}.size
