require 'set'
m = []
dd = (-1..1).to_a.product((-1..1).to_a).select {|a,b| (a.abs + b.abs).eql?(1)}

def dbg(m)
  puts "-"*20
  m.size.times do |y|
    m[0].size.times do |x|
      print m[y][x]
    end
    print "\n"
  end
end

def dbgv(m,v)
  puts "-"*20
  m.size.times do |y|
    m[0].size.times do |x|
      if v.include?([y,x])
        print "O"
      else
        print m[y][x]
      end
    end
    print "\n"
  end
end

def find_start(m)
  m.size.times do |y|
    m[0].size.times do |x|
      return [y,x] if m[y][x].eql?(".")
    end
  end
end

def find_end(m)
  found_end = nil
  m.size.times do |y|
    m[0].size.times do |x|
      found_end = [y,x] if m[y][x].eql?(".")
    end
  end
  return found_end
end

def find_junctions(m, dd)
    junctions = []
    m.size.times do |y|
        m[0].size.times do |x|
            next if m[y][x].eql?("#") 
            count = 0
            dd.each do |dp|
                npos = [y+dp[0], x+dp[1]]
                next if npos[0] < 0 || npos[0] >= m.size
                next if npos[1] < 0 || npos[1] >= m[0].size
                next if m[npos[0]][npos[1]].eql?("#") 
                count += 1
            end
            junctions << [y,x] if count > 2
        end
    end
    junctions
end

def find_junction_neighbour(jc, all_jc, m)
    dd = (-1..1).to_a.product((-1..1).to_a).select {|a,b| (a.abs + b.abs).eql?(1)}
    visited = Set.new
    visited << jc
    exp = []
    dd.each do |dp|
        npos = [jc[0]+dp[0], jc[1]+dp[1]]
        next if npos[0] < 0 || npos[0] >= m.size
        next if npos[1] < 0 || npos[1] >= m[0].size
        next if m[npos[0]][npos[1]].eql?("#") 
        exp << [npos, 1]
    end
    t_exp = []
    while !exp.empty?
        ep, dst = exp.shift
        next if visited.include?(ep)
        visited << ep 
        if all_jc.include?(ep)
            t_exp << [ep, dst]
        else
            # try to expand it
            dd.each do |dp|
                npos = [ep[0]+dp[0], ep[1]+dp[1]]
                next if npos[0] < 0 || npos[0] >= m.size
                next if npos[1] < 0 || npos[1] >= m[0].size
                next if m[npos[0]][npos[1]].eql?("#") 
                exp << [npos, dst + 1]
            end
        end
    end
    t_exp
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  m << line.split("").collect do |x|
    if x.eql?("#")
        x
    else
        "."
    end 
  end
end

jn = find_junctions(m,dd)
st = find_start(m)
en = find_end(m)
# add start and end to the junctions
jn << st
jn << en

h = {}

# now for every junction find neighbours
jn.each do |j|
    find_junction_neighbour(j, jn, m).each do |ne, nv|
        # j --X--> ng 
        h[j]||={}
        h[j][ne]=nv
    end
end
puts h.inspect

def explore(current, target, score, visited, h, acc)
    # puts "#{current} ==#{score}==> #{target}"
    if current.eql?(target)
        acc[:cnt] += 1
        print "." if (acc[:cnt] % 1000).eql?(0)
        acc[:max] = score if score > acc[:max]
        acc[:min] = score if score < acc[:min]
    else
        visited << current
        h[current].each do |next_node, value|
            next if visited.include?(next_node)
            explore(next_node, target, score+value, visited, h, acc)
        end
        visited.delete(current)

    end
end

acc = {:max => 0, :min => 2*m.size*m[0].size, :cnt => 0}
explore(st, en, 0, Set.new, h, acc)
print "\n"
puts acc.inspect
puts "=" * 20
puts acc[:max]