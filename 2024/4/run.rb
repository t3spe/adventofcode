r = {}
idx = 0
rdx = nil
d = (-1..1).to_a.product((-1..1).to_a) - [[0,0]]

def is_xmas?(r, d, x, y)
  w = "XMAS"
  w.size.times do |p|
    return false unless r[[x+p*d[0],y+p*d[1]]].eql?(w[p])
  end
  true
end


File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  ls = line.split("")
  ls.size.times do |cdx|
    r[[idx,cdx]] = ls[cdx]
  end
  idx+=1
  rdx = ls.size
end

cnt = 0
idx.times do |x|
  rdx.times do |y|
    d.size.times do |d1|
      cnt +=1 if is_xmas?(r,d[d1],x,y)
    end
  end
end
puts cnt.inspect