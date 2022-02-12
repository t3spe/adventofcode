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

def serialize(w1)
  s = []
  w1.each { |w11| s += w11 }
  s.join("")
end

seen = {}
delta = nil
maxiter = 1000000000
w2 = Array.new(w1.size) { Array.new(w1[0].size) { "." } }

1000000000.times do |itr|
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
  sr = serialize(w1)
  if seen.key?(sr)
    if delta.nil?
      delta = itr - seen[sr][-1]
    else
      if (maxiter - itr - 1) % delta == 0
        # when we would need to look delta times stop
        # as we have the stable configuration already
        break
      end
    end
    seen[sr] << itr
  else
    seen[sr] = [itr]
  end
end

trees, lumber = 0, 0
w1.size.times do |x|
  w1[0].size.times do |y|
    trees += 1 if w1[x][y].eql?("|")
    lumber += 1 if w1[x][y].eql?("#")
  end
end

puts "trees: #{trees}"
puts "lumber: #{lumber}"
res = trees * lumber

puts "=" * 80
puts res
