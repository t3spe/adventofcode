w1 = []

neg = (-1..1).to_a.product((-1..1).to_a) - [[0, 0]]

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  w1 << line.split("")
end

def collect_n(w1, n, x, y)
  sym = {}
  sym["."] = 0
  sym["|"] = 0
  sym["#"] = 0
  n.each do |ne|
    px = x + ne[0]
    py = y + ne[1]
    next if px < 0 || py < 0 || px >= w1.size || py >= w1[0].size
    sym[w1[px][py]] += 1
  end
  sym
end

v = [0, 0]
stable = 0
w2 = Array.new(w1.size) { Array.new(w1[0].size) { "." } }

10.times do |itr|
  print "..#{v.join("-")}" if (itr + 1) % 1000 == 0
  w1.size.times do |x|
    w1[0].size.times do |y|
      o = w1[x][y]
      ns = collect_n(w1, neg, x, y)
      r = o
      case o
      when "."
        r = "|" if ns["|"] >= 3
      when "|"
        r = "#" if ns["#"] >= 3
      when "#"
        r = "." unless ns["|"] >= 1 && ns["#"] >= 1
      end
      w2[x][y] = r
    end
  end
  w1, w2 = w2, w1

  trees = 0
  lumber = 0

  w1.size.times do |x|
    w1[0].size.times do |y|
      trees += 1 if w1[x][y].eql?("|")
      lumber += 1 if w1[x][y].eql?("#")
    end
  end
  cv = [trees, lumber]
  if v.eql?(cv)
    stable += 1
  else
    v = cv
    stable = 0
  end
  break if stable >= 50
end

trees, lumber = v

print "\n"
puts "stable: #{stable}"
puts "trees: #{trees}"
puts "lumber: #{lumber}"
res = trees * lumber

puts "=" * 80
puts res
