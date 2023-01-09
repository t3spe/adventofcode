require 'set'
v = {}

def compute_hops(v)
  v.keys.each do |s|
    visited = Set.new
    q = []
    q << [s, 0]
    while !q.empty?
      n, c = q.shift
      visited << n
      v[s][:hops][n] = c + 1 unless c.eql?(0)
      v[n][:to].each do |tn|
        q << [tn, c+1] unless visited.include?(tn)
      end
    end
  end
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  fp, sp = line.split(";")
  fpf = fp.split(" ")
  valve = fpf[1]
  flow = fpf[-1].split("=")[-1].to_i
  v[valve]||={}
  v[valve][:rate] = flow
  v[valve][:to]||=[]
  v[valve][:hops]||={}
  targets = sp.split("valve")[-1].gsub(" ","").gsub("s","").split(",")
  targets.each do |t|
    v[valve][:to] << t
  end 
end

compute_hops(v)
# prune the search tree
keys_keep = v.reject {|k,v| v[:rate].eql?(0)}.keys + ["AA"]
v.keys.each do |k|
  unless keys_keep.include?(k)
    v.delete(k) 
  else
    v[k].delete(:to)
    v[k][:hops].keys.each do |hk|
      v[k][:hops].delete(hk) unless keys_keep.include?(hk)
    end
    v[k][:hops].delete("AA")
  end
end

def combo_eval(combo, nodes)
  t = 30
  p = "AA"
  flow = 0
  # raise "101"
  combo.each do |el|
    next if el.eql?("AA")
    t -= nodes[p][:hops][el]
    break if t <= 0
    flow += t * nodes[el][:rate] 
    p = el
  end
  short = false
  short = true if t <= 0
  return [flow, short]
end

cnt = 1
cmax = 0
q = [["AA"]]
while !q.empty?
  print "." if (cnt % 1000).eql?(0)
  cnt += 1
  c = q.shift
  nmax, short = combo_eval(c, v)
  if nmax > cmax
    print nmax
    print "."
    cmax = nmax
  end
  next if short
  ce = c[-1]
  v[ce][:hops].keys.each do |k|
    next if c.include?(k)
    q << c + [k]
  end
end

print "\n"
puts cmax