f = []
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).collect do |line|
  f << line.split("").collect(&:to_i)
end

def neg(x, y, m, n)
  [[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]].reject do |p|
    p[0] < 0 || p[1] < 0 || p[0] >= m || p[1] >= n
  end
end

def explore(x, y, m, n, f)
  return 0 if f[x][y].eql?(9)
  f[x][y] = 9
  1 + neg(x, y, m, n).collect { |x1, y1| explore(x1, y1, m, n, f) }.sum
end

m = f.size
n = f[0].size
bas = []

m.times do |x|
  n.times do |y|
    b = explore(x, y, m, n, f)
    bas << b if b > 0
  end
end
puts bas.sort.reverse.take(3).inject(1) { |a, c| a * c }
