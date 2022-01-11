require "set"

f = []
markers = {}

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  f << line.split("")
end

def distance(s, e)
  (s[0] - e[0]) * (s[0] - e[0]) + (s[1] - e[1]) * (s[1] - e[1])
end

def neg(c, t, f)
  m = f.size
  n = f[0].size
  cmp = [[1, 0], [-1, 0], [0, -1], [0, 1]].collect do |d|
    [c[0] + d[0], c[1] + d[1]]
  end.reject do |d|
    d[0] < 0 || d[0] >= m || d[1] < 0 || d[1] >= n || f[d[0]][d[1]].eql?("#")
  end
  # this will "optimize" finding the shortest path
  # by sorting the neighbors in an order that is closer
  # to the target node
  unless t.nil?
    cmp = cmp.sort_by { |x| distance(x, t) }
  end
  cmp
end

def path(s, e, f)
  memo = Set.new
  q = []
  q << [s, []]
  pos = 0
  while !q.empty?
    c = q.shift
    pos += 1
    next if memo.include?(c[0])
    memo << c[0]
    # return path + current element
    if c[0].eql?(e)
      return c[1] + [c[0]]
    end
    neg(c[0], e, f).each do |r|
      next if c[1].include?(r)
      q << [r, c[1] + [c[0]]]
    end
  end
end

f.size.times do |m|
  f[0].size.times do |n|
    unless ["#", "."].include?(f[m][n])
      markers[f[m][n].to_i] = [m, n]
      f[m][n] = "."
    end
  end
end

def print_path(f, p1, p2)
  f.size.times do |m|
    f[0].size.times do |n|
      c = "."
      c = "A" if !p1.nil? && p1.include?([m, n])
      c = "B" if !p2.nil? && p2.include?([m, n])
      print c
    end
    print "\n"
  end
end

d = {}

# now generate all the pairs
markers.keys.combination(2).each do |s, e|
  d[[s, e]] = d[[e, s]] = path(markers[s], markers[e], f).size - 1
end

min_sum = f.size * f[0].size * 2
non_zero_nodes = (markers.keys - [0]).sort
non_zero_nodes.permutation(non_zero_nodes.size).each do |ch|
  cf = [0] + ch
  csum = 0
  (cf.size - 1).times do |idx|
    csum += d[[cf[idx], cf[idx + 1]]]
  end
  if csum < min_sum
    min_sum = csum
  end
  # puts "#{cf} -> #{csum} (#{min_sum})"
end

puts min_sum.inspect
