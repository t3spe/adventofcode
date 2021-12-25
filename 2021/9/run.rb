f = []
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).collect do |line|
  f << line.split("").collect(&:to_i)
end

def neg(x, y, m, n)
  [[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]].reject do |p|
    p[0] < 0 || p[1] < 0 || p[0] >= m || p[1] >= n
  end
end

m = f.size
n = f[0].size
sum = 0

m.times do |x|
  n.times do |y|
    sum += 1 + f[x][y] if neg(x, y, m, n).all? { |x1, y1| f[x1][y1] > f[x][y] }
  end
end

puts sum.inspect
