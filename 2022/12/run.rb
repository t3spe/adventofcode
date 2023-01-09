require 'set'
mat = []
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  mat << line.split("").collect do |c|
    case c
    when 'S'
      -1
    when 'E'
      -2
    else
      c.ord - 'a'.ord
    end
  end
end

neg = (-1..1).to_a.product((-1..1).to_a).select {|x,y| (x+y).abs.eql?(1)}
def pos(cp, m, n, neg)
  neg.collect {|dm, dn| [cp[0]+dm, cp[1]+dn]}.select do |fm,fn|
    fm >= 0 && fn >= 0 && fm < m && fn < n
  end
end
s = nil
e = nil

mat[0].size.times do |m|
  mat.size.times do |n|
    s = [n,m] if mat[n][m].eql?(-1)
    e = [n,m] if mat[n][m].eql?(-2)
  end
end

n = mat.size
m = mat[0].size
mat[s[0]][s[1]]=0
mat[e[0]][e[1]]=25

mat.size.times do |n|
mat[0].size.times do |m|
    print ('a'.ord+mat[n][m]).chr
  end
  print "\n"
end

puts e.inspect

v = Set.new
q = []
q << [s, 0]
while !q.empty?
  p, ex = q.shift
  next if v.include?(p)
  v << p
  pos(p, n, m, neg).each do |np|
    next unless (mat[np[0]][np[1]] < mat[p[0]][p[1]]) || ((mat[np[0]][np[1]] >= mat[p[0]][p[1]]) && (mat[np[0]][np[1]] < mat[p[0]][p[1]]+2))
    # puts "#{np}"
    if np.eql?(e)
      puts ex+1
      exit 0
    end
    q << [np, ex + 1] 
  end
end
raise "here"
