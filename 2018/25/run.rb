require "set"

points = []
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  points << line.split(",").collect(&:to_i)
end

def distance(p1, p2)
  dist = 0
  p1.size.times do |c|
    dist += (p1[c] - p2[c]).abs
  end
  dist
end

visited = Set.new
ph = {}

points.combination(2).each do |p1, p2|
  ph[p1] ||= []
  ph[p2] ||= []
  if distance(p1, p2) <= 3
    ph[p1] << p2
    ph[p2] << p1
  end
end

groups = 0
points.each do |p|
  next if visited.include?(p)
  groups += 1
  q = [p]
  while !q.empty?
    tovisit = q.shift
    next if visited.include?(tovisit)
    visited << tovisit
    ph[tovisit].each do |p2|
      q << p2 unless visited.include?(p2)
    end
  end
end

puts groups
