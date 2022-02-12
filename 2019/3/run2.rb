require "set"

wires = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  wires << line.split(",").collect { |x| [x[0], x[1..].to_i] }
end

def points_on_line(line)
  a, b = line
  if a[0].eql?(b[0])
    s, e = [a[1], b[1]].minmax
    s.upto(e).each do |py|
      yield [a[0], py]
    end
  elsif a[1].eql?(b[1])
    s, e = [a[0], b[0]].minmax
    s.upto(e).each do |px|
      yield [px, a[1]]
    end
  else
    raise "unsupported #{a} <-> #{b}"
  end
end

def intesect(p0, p1)
  p0points = Set.new
  finalPoints = Set.new
  points_on_line(p0) { |point| p0points << point }
  points_on_line(p1) { |point| finalPoints << point if p0points.include?(point) }
  finalPoints
end

seg = wires.collect do |wr|
  origin = [0, 0]
  segments = wr.collect do |s|
    segment = []
    segment << origin.dup
    case s[0]
    when "L"
      origin[0] -= s[1]
    when "R"
      origin[0] += s[1]
    when "U"
      origin[1] -= s[1]
    when "D"
      origin[1] += s[1]
    else
      raise "unknown instruction #{s[0]}"
    end
    segment << origin.dup
    segment
  end
  segments
end

raise "need 2 chains" unless seg.size.eql?(2)
acc = []
puts seg[0].size * seg[1].size
cnt = 0

ipoints = seg[0].product(seg[1]).each do |s1, s2|
  cnt += 1
  print "." if cnt % 100 == 0
  acc += intesect(s1, s2).to_a
end
acc -= [[0, 0]]
print "\n"
puts acc.inspect

# acc are intersections
# now we need to go through the wires and mark where we
# hit the points

wire_steps = {}
acc.each do |a|
  wire_steps[a] = [Float::INFINITY, Float::INFINITY]
end

wire = 0
wires.each do |wr|
  origin = [0, 0]
  steps = 0
  wr.each do |s|
    s[1].times do
      case s[0]
      when "L"
        origin[0] -= 1
      when "R"
        origin[0] += 1
      when "U"
        origin[1] -= 1
      when "D"
        origin[1] += 1
      else
        raise "unknown instruction #{s[0]}"
      end
      # it was progressed
      steps += 1
      if acc.include?(origin)
        wire_steps[origin][wire] = [wire_steps[origin][wire], steps].min
      end
    end
  end
  wire += 1
end

min_combined_steps = wire_steps.values.collect { |a, b| a + b }.sort.first
puts "=" * 80
puts min_combined_steps
