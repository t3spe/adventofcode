g = {}
y = 0
maxx = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  line.split("").each_with_index do |e, i|
    g[[i, y]] = e
    maxx = [maxx, i + 1].max
  end
  y += 1
end

trees = 0
maxy = y

curr = [0, 0]
while curr[1] < maxy
  trees += 1 if g[curr].eql?("#")
  currx = (curr[0] + 3) % maxx
  curry = curr[1] + 1
  curr = [currx, curry]
end

puts "=" * 80
puts trees
