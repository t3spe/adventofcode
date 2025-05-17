require 'set'

h={}
cl=0
dd = ((-1..1).to_a.product((-1..1).to_a) - [[0,0]]).reject {|a,b| (a.abs+b.abs).eql?(2)}

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  line.split("").collect(&:to_i).each_with_index do |e,i|
    h[[i,cl]]=e
  end
  cl+=1
end

def explore(h, th, d, p, acc)
  if h[th].eql?(9)
    p << th
    acc << p.dup
    p.pop
    return
  end

  d.each do |d1|
    if h.key?([th[0]+d1[0],th[1]+d1[1]]) && h[[th[0]+d1[0],th[1]+d1[1]]].eql?(h[th]+1)
        p << th
        explore(h, [th[0]+d1[0],th[1]+d1[1]], d, p, acc)
        p.pop
    end
  end
end

sum=0
h.select {|k,v| v.eql?(0)}.keys.each do |th|
  paths = Set.new
  explore(h, th, dd, [], paths)
  sum += paths.size
end
puts sum

