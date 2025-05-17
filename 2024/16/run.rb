require 'set'

mx = 0
my = 0
h = {}
st = nil
en = nil
dr = ((-1..1).to_a.product((-1..1).to_a) - [[0,0]]).reject {|a,b| (a.abs+b.abs).eql?(2)}

def debug(h, mx, my)
  my.times do |yy|
    mx.times do |xx|
      print h[[xx,yy]]
    end
    puts ""
  end
end

def debug_with_path(h, mx, my, path)
  puts path.inspect
  path.each do |pf,ps|
    h[pf] = "*"
  end
  debug(h, mx, my)
  path.each do |pf,ps|
    h[pf] = "."
  end
end

def compute_score(path)
  cost = 0
  (path.size-1).times do |i|
    cost += 1
    cost += 1000 if path[i][1] != path[i+1][1]
  end
  cost
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  line.split("").each_with_index do |e,i|
    mx = [mx, i+1].max
    h[[i,my]] = e
    st = [i,my] if e.eql?("S")
    en = [i,my] if e.eql?("E")
    h[[i,my]] = "." unless h[[i,my]].eql?("#")
  end
  my += 1
end

# debug(h, mx, my)
mincost = nil
costs = {}

# id is the initial direction
q = [[[st, [1,0]]]]
while !q.empty?
  path = q.shift
  csc = compute_score(path)
  next if costs.key?(path[-1]) && costs[path[-1]] <= csc
  costs[path[-1]] = csc
  # puts path.inspect
  #debug_with_path(h, mx, my, path)
  if path[-1][0].eql?(en)
    # debug_with_path(h, mx, my, path)
    # puts "score: #{csc}"
    if mincost.nil?
      mincost = csc
    else
      mincost = [mincost, csc].min
    end
    next
  end   
  c = path[-1]
  dr.each do |nd|
    next if (nd[0]+c[1][0]).eql?(0) && (nd[1]+c[1][1]).eql?(0)
    ncp = [c[0][0]+nd[0], c[0][1]+nd[1]]
    next unless h.key?(ncp) && h[ncp].eql?(".")
    next if path.collect(&:first).include?(ncp)
    pdup = path.dup()
    pdup << [ncp, nd]
    q << pdup
  end
end

puts "mincost: #{mincost}"