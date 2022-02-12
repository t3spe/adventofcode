require "set"
points = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  points << line.split(",").collect(&:to_i)
end

def distance(p0, p1)
  (p0[0] - p1[0]).abs + (p0[1] - p1[1]).abs
end

def point_distance_sum(p, points)
  points.collect { |s| distance(s, p) }.sum
end

x0, x1 = points.collect { |p| p[0] }.minmax
y0, y1 = points.collect { |p| p[1] }.minmax

c = ((x1 - x0).abs + (y1 - y0.abs))
c = 100
x0 -= c
x1 += c
y0 -= c
y1 += c

puts "exploring [#{x0}, #{y0}] <-> [#{x1}, #{y1}]"
lsize = 0

y0.upto(y1).each do |yc|
  x0.upto(x1).each do |xc|
    res = point_distance_sum([xc, yc], points)
    lsize += 1 if res < 10000
  end
end

puts lsize
