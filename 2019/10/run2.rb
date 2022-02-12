input = []
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  input << line.split("")
end

pos = []

def slope(s1, s2)
  (s2[1] - s1[1]) * 1.0 / (s2[0] - s1[0])
end

def find_location(pos)
  acc = {}

  pos.each do |p|
    conn = 0
    slopes = {}
    # the infinity slope
    infs = pos.select { |p1| p1[0].eql?(p[0]) }
    conn += 1 if infs.select { |p1| p1[1] < p[1] }.size > 0
    conn += 1 if infs.select { |p1| p1[1] > p[1] }.size > 0
    # zero slopes
    zeros = pos.select { |p1| p1[1].eql?(p[1]) }
    conn += 1 if zeros.select { |p1| p1[0] < p[0] }.size > 0
    conn += 1 if zeros.select { |p1| p1[0] > p[0] }.size > 0
    noo = pos - infs - zeros
    noo.collect do |p2|
      slopes[slope(p, p2)] ||= []
      slopes[slope(p, p2)] << p2
    end
    slopes.keys.each do |sk|
      conn += 1 if slopes[sk].select { |p1| p1[1] < p[1] }.size > 0
      conn += 1 if slopes[sk].select { |p1| p1[1] > p[1] }.size > 0
    end
    acc[p] = conn
  end
  res = acc.to_a.sort_by { |a, b| -b }.take(20).first[0]
  puts acc[res]
  res
end

input.size.times do |m|
  input[0].size.times do |n|
    print input[m][n]
    pos << [m, n] if input[m][n].eql?("#")
  end
  print "\n"
end

station = find_location(pos)
puts station.inspect

# found the station - we're in the endgame now

infs = pos.select { |p1| p1[0].eql?(station[0]) }
zeros = pos.select { |p1| p1[1].eql?(station[1]) }

slopes = {}
noo = pos - [station] - infs - zeros
noo.collect do |p2|
  slopes[slope(station, p2)] ||= []
  slopes[slope(station, p2)] << p2
end

removed = []

while removed.size < 200

  # now the circle
  # || slope 0 w/ X>SX, (1)
  s0 = zeros.select { |p1| p1[0] < station[0] }.sort_by { |p1| p1[0] }.last
  unless s0.nil?
    removed << s0
    zeros -= [s0]
  end
  # || slope -0 -> -INF, w/ Y > SY
  slopes.keys.select { |k| k < 0 }.sort.reverse.each do |s|
    s0 = slopes[s].select { |p1| p1[1] > station[1] }.sort_by { |p1| p1[0] }.last
    unless s0.nil?
      removed << s0
      slopes[s] -= [s0]
    end
  end

  # || slope INF w/ Y<SY
  s0 = infs.select { |p1| p1[1] > station[1] }.sort_by { |p1| p1[1] }.first
  unless s0.nil?
    removed << s0
    infs -= [s0]
  end

  # || slope INF- -> 0 w/ Y < SY,
  slopes.keys.select { |k| k > 0 }.sort.reverse.each do |s|
    s0 = slopes[s].select { |p1| p1[1] > station[1] }.sort_by { |p1| p1[0] }.first
    unless s0.nil?
      removed << s0
      slopes[s] -= [s0]
    end
  end

  # || slope 0 w/ X<SX,
  s0 = zeros.select { |p1| p1[0] > station[0] }.sort_by { |p1| p1[0] }.first
  unless s0.nil?
    removed << s0
    zeros -= [s0]
  end

  slopes.keys.select { |k| k < 0 }.sort.reverse.each do |s|
    s0 = slopes[s].select { |p1| p1[1] < station[1] }.sort_by { |p1| p1[0] }.first
    unless s0.nil?
      removed << s0
      slopes[s] -= [s0]
    end
  end

  # || slope INF w/ Y<SY
  s0 = infs.select { |p1| p1[1] < station[1] }.sort_by { |p1| p1[1] }.last
  unless s0.nil?
    removed << s0
    infs -= [s0]
  end

  # || slope -0 -> -INF, w/ Y > SY
  slopes.keys.select { |k| k > 0 }.sort.reverse.each do |s|
    s0 = slopes[s].select { |p1| p1[1] < station[1] }.sort_by { |p1| p1[0] }.last
    unless s0.nil?
      removed << s0
      slopes[s] -= [s0]
    end
  end
end

# 200th element
puts removed[199].inspect
res = removed[199][1] * 100 + removed[199][0]

puts "=" * 80
puts res

# input.size.times do |m|
#   input[0].size.times do |n|
#     if [m, n].eql?(station)
#       print "X"
#     elsif removed.include?([m, n])
#       print "."
#     else
#       print input[m][n]
#     end
#   end
#   print "\n"
# end
