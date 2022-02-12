require "set"
points = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  points << line.split(",").collect(&:to_i)
end

def distance(p0, p1)
  (p0[0] - p1[0]).abs + (p0[1] - p1[1]).abs
end

def point_distance(p, points)
  r = points.collect { |s| [distance(s, p), s] }.sort.take(2)
  return nil if r[0][0].eql?(r[1][0])
  return r[0][1]
end

def build_smap(points)
  sm = {}
  chrs = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
  pos = 0
  points.each do |p|
    sm[p] = chrs[pos]
    pos += 1
  end
  sm[nil] = "."
  sm
end

x0, x1 = points.collect { |p| p[0] }.minmax
y0, y1 = points.collect { |p| p[1] }.minmax
sm = build_smap(points)

edge = Set.new

c = ((x1 - x0).abs + (y1 - y0.abs))
c = 100
x0 -= c
x1 += c
y0 -= c
y1 += c

puts "exploring [#{x0}, #{y0}] <-> [#{x1}, #{y1}]"

tracker = {}

y0.upto(y1).each do |yc|
  x0.upto(x1).each do |xc|
    res = sm[point_distance([xc, yc], points)]
    tracker[res] ||= 0
    tracker[res] += 1
    edge << res if xc.eql?(x0) || xc.eql?(x1) || yc.eql?(y0) || yc.eql?(y1)
  end
end

tracker.delete(".")
edge.to_a.each { |infn| tracker.delete(infn) }

puts tracker.inspect
puts tracker.values.max
