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

trees = []
slopes = [1, 1], [3, 1], [5, 1], [7, 1], [1, 2]
maxy = y

slopes.each do |slope|
  trees << 0
  curr = [0, 0]
  while curr[1] < maxy
    trees[-1] += 1 if g[curr].eql?("#")
    currx = (curr[0] + slope[0]) % maxx
    curry = curr[1] + slope[1]
    curr = [currx, curry]
  end
end

res = trees.inject(1) { |a, c| a *= c }
puts "=" * 80
puts res.inspect
