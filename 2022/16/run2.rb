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

def combo_eval(combo, nodes, memo, tg = 26)
  return memo[combo] if memo.key?(combo)
  if combo.size > 2
    2.upto(combo.size) do |plen|
        prefix_key = combo[0, plen]
        return memo[:prefixes][prefix_key] if memo[:prefixes].key?(prefix_key)
    end
  end
  t = tg
  p = "AA"
  flow = 0
  combo.each do |el|
    next if el.eql?("AA")
    t -= nodes[p][:hops][el]
    break if t <= 0
    flow += t * nodes[el][:rate] 
    p = el
  end
  short = false
  short = true if t <= 0
  memo[combo] = [flow, short]
  if t<=0
    memo[:prefixes] ||= {}
    memo[:prefixes][combo] = [flow, short]
  end
  return [flow, short]
end

def elephant_combo_eval(combo, nodes, memo)
    hcombo = combo[1..]
    max = [0, true]
    1.upto(hcombo.size).each do |cz|
        hcombo.combination(cz).each do |ccomb|
            fp = [combo[0]] + ccomb
            sp = combo - fp
            sp = [combo[0]] + sp
            # compute
            c1 = combo_eval(fp, nodes, memo)
            c2 = combo_eval(sp, nodes, memo)
            if (c1[0] + c2[0]) > max[0]
                max = [c1[0] + c2[0], true] 
            end 
        end
    end
    return max
end

cnt = 1
cmax = 0
memo = {prefixes: {}}

q = [["AA"]]
while !q.empty?
  print "." if (cnt % 1000).eql?(0)
  cnt += 1
  c = q.shift
  nmax, short2 = elephant_combo_eval(c, v, memo)
  if nmax > cmax
    print nmax
    print "."
    cmax = nmax
  end
#   lmax, short = combo_eval(c,v,{}, 26 * 2)
#   next if short
  ce = c[-1]
  v[ce][:hops].keys.each do |k|
    next if c.include?(k)
    q << c + [k]
  end
end

print "\n"
puts cmax